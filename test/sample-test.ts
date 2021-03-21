const { expect } = require("chai");
import {ethers} from 'hardhat'
import { Signer } from "ethers"

describe("ZombieFactory", function() {
  it("Should return the ZombieFactory", async function() {
    const ZombieFactory = await ethers.getContractFactory("ZombieFactory");
    const zombieFactory = await ZombieFactory.deploy();
    await zombieFactory.deployed();
    await zombieFactory.createRandomZombie("zombie");
  });
});
