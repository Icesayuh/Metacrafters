// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/**
 * @title GuevarraTokenVestingManager
 * @dev Manages token vesting schedules for different organizations and stakeholders
 */
contract GuevarraTokenVestingManager {
    using SafeMath for uint256;

    address public owner;

    struct Organization {
        address tokenAddress;
        bool isRegistered;
        mapping(address => bool) admins;
        mapping(bytes32 => StakeholderType) stakeholderTypes;
        mapping(address => Vesting) vestings;
    }

    struct StakeholderType {
        string name;
        uint256 vestingPeriod;
    }

    struct Vesting {
        bytes32 stakeholderTypeId;
        uint256 amount;
        uint256 startTime;
        uint256 claimedAmount;
    }

    mapping(address => Organization) public organizations;

    event OrganizationRegistered(address indexed orgAddress, address indexed tokenAddress);
    event AdminAdded(address indexed orgAddress, address indexed adminAddress);
    event StakeholderTypeAdded(address indexed orgAddress, bytes32 indexed typeId, string name, uint256 vestingPeriod);
    event VestingScheduleCreated(address indexed orgAddress, address indexed beneficiary, bytes32 stakeholderTypeId, uint256 amount);
    event TokensClaimed(address indexed orgAddress, address indexed beneficiary, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    modifier onlyOrgAdmin(address _orgAddress) {
        require(organizations[_orgAddress].admins[msg.sender], "Caller is not an organization admin");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner is the zero address");
        owner = newOwner;
    }

    /**
     * @dev Register a new organization and its token
     * @param _tokenAddress The address of the organization's ERC20 token
     */
    function registerOrganization(address _tokenAddress) external {
        require(!organizations[msg.sender].isRegistered, "Organization already registered");
        require(_tokenAddress != address(0), "Invalid token address");

        Organization storage org = organizations[msg.sender];
        org.tokenAddress = _tokenAddress;
        org.isRegistered = true;
        org.admins[msg.sender] = true;

        emit OrganizationRegistered(msg.sender, _tokenAddress);
        emit AdminAdded(msg.sender, msg.sender);
    }


    /**
     * @dev Add a new admin for the organization
     * @param _adminAddress The address of the new admin
     */
    function addAdmin(address _adminAddress) external onlyOrgAdmin(msg.sender) {
        require(_adminAddress != address(0), "Invalid admin address");
        organizations[msg.sender].admins[_adminAddress] = true;
        emit AdminAdded(msg.sender, _adminAddress);
    }

    /**
     * @dev Add a new stakeholder type for the organization
     * @param _name The name of the stakeholder type
     * @param _vestingPeriod The vesting period in seconds
     */
    function addStakeholderType(string memory _name, uint256 _vestingPeriod) external onlyOrgAdmin(msg.sender) {
        bytes32 typeId = keccak256(abi.encodePacked(_name));
        require(organizations[msg.sender].stakeholderTypes[typeId].vestingPeriod == 0, "Stakeholder type already exists");

        organizations[msg.sender].stakeholderTypes[typeId] = StakeholderType(_name, _vestingPeriod);
        emit StakeholderTypeAdded(msg.sender, typeId, _name, _vestingPeriod);
    }

    /**
     * @dev Create a vesting schedule for a beneficiary
     * @param _beneficiary The address of the beneficiary
     * @param _stakeholderTypeId The ID of the stakeholder type
     * @param _amount The amount of tokens to vest
     */
    function createVestingSchedule(address _beneficiary, bytes32 _stakeholderTypeId, uint256 _amount) external onlyOrgAdmin(msg.sender) {
        require(_beneficiary != address(0), "Invalid beneficiary address");
        require(organizations[msg.sender].stakeholderTypes[_stakeholderTypeId].vestingPeriod > 0, "Invalid stakeholder type");
        require(_amount > 0, "Amount must be greater than 0");

        Organization storage org = organizations[msg.sender];
        require(org.vestings[_beneficiary].amount == 0, "Vesting schedule already exists for beneficiary");

        IERC20 token = IERC20(org.tokenAddress);
        require(token.transferFrom(msg.sender, address(this), _amount), "Token transfer failed");

        org.vestings[_beneficiary] = Vesting(_stakeholderTypeId, _amount, block.timestamp, 0);
        emit VestingScheduleCreated(msg.sender, _beneficiary, _stakeholderTypeId, _amount);
    }

    /**
     * @dev Claim vested tokens
     * @param _orgAddress The address of the organization
     */
    function claimTokens(address _orgAddress) external {
        Organization storage org = organizations[_orgAddress];
        require(org.isRegistered, "Organization not registered");

        Vesting storage vesting = org.vestings[msg.sender];
        require(vesting.amount > 0, "No vesting schedule found for beneficiary");

        StakeholderType memory stakeholderType = org.stakeholderTypes[vesting.stakeholderTypeId];
        uint256 vestedAmount = calculateVestedAmount(vesting, stakeholderType.vestingPeriod);
        uint256 claimableAmount = vestedAmount.sub(vesting.claimedAmount);

        require(claimableAmount > 0, "No tokens available to claim");

        vesting.claimedAmount = vesting.claimedAmount.add(claimableAmount);
        IERC20(org.tokenAddress).transfer(msg.sender, claimableAmount);

        emit TokensClaimed(_orgAddress, msg.sender, claimableAmount);
    }

    /**
     * @dev Calculate the vested amount of tokens
     * @param _vesting The vesting schedule
     * @param _vestingPeriod The vesting period in seconds
     * @return The vested amount of tokens
     */
    function calculateVestedAmount(Vesting memory _vesting, uint256 _vestingPeriod) internal view returns (uint256) {
        if (block.timestamp >= _vesting.startTime.add(_vestingPeriod)) {
            return _vesting.amount;
        } else {
            return _vesting.amount.mul(block.timestamp.sub(_vesting.startTime)).div(_vestingPeriod);
        }
    }

    /**
     * @dev Get vesting information for a beneficiary
     * @param _orgAddress The address of the organization
     * @param _beneficiary The address of the beneficiary
     * @return stakeholderTypeId The ID of the stakeholder type
     * @return amount The total amount of tokens in the vesting schedule
     * @return startTime The start time of the vesting schedule
     * @return claimedAmount The amount of tokens already claimed
     */
    function getVestingInfo(address _orgAddress, address _beneficiary) external view returns (bytes32 stakeholderTypeId, uint256 amount, uint256 startTime, uint256 claimedAmount) {
        Vesting storage vesting = organizations[_orgAddress].vestings[_beneficiary];
        return (vesting.stakeholderTypeId, vesting.amount, vesting.startTime, vesting.claimedAmount);
    }
}