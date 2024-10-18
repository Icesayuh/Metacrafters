// scripts/deploy.js
const { ethers } = require("hardhat");

async function main() {
    // Get the contract factory
    const SaiTok = await ethers.getContractFactory("SaiTok");
    // Deploy the contract
    const saiTok = await SaiTok.deploy();
    await saiTok.deployed();
    console.log("SaiTok deployed to:", saiTok.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
