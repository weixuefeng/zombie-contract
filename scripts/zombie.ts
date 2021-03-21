// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import {run, ethers} from "hardhat"

async function main() {
    // Hardhat always runs the compile task when running scripts with its command
    // line interface.
    //
    // If this script is run directly using `node` you may want to call compile
    // manually to make sure everything is compiled
    const ZombieFactory = await ethers.getContractFactory("ZombieFactory");
    const zombieContract = ZombieFactory.attach("0x5FbDB2315678afecb367f032d93F642f64180aa3");
    const transactionResponse = await zombieContract.functions.createRandomZombie("weixuefeng");
    console.log(transactionResponse);
    if(transactionResponse.wait) {
        console.log(transactionResponse.wait.event);
    }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
