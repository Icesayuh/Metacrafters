// scripts/deploy.js
const hre = require("hardhat");

async function main() {
    const SaiTok = await hre.ethers.getContractFactory("SaiTok");
    const saiTok = await SaiTok.deploy(); // No initial supply needed
    await saiTok.deployed();

    console.log(`SaiTok deployed to: ${saiTok.address}`);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});