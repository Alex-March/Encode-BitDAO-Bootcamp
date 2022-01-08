const { expect, use } = require("chai");
const { ethers } = require("hardhat");
const {
  constants, // Common constants, like the zero address and largest integers
  expectRevert, // Assertions for transactions that should fail
} = require("@openzeppelin/test-helpers");

const { solidity } = require("ethereum-waffle");
use(solidity);

// https://www.chaijs.com/guide/styles/
// https://ethereum-waffle.readthedocs.io/en/latest/matchers.html

describe("Volcano Coin", () => {
  let volcanoContract;
  let owner, addr1, addr2, addr3;

  beforeEach(async () => {
    const Volcano = await ethers.getContractFactory("VolcanoCoin");
    volcanoContract = await Volcano.deploy();
    await volcanoContract.deployed();

    [owner, addr1, addr2, addr3] = await ethers.getSigners();
  });

  it("has a name", async () => {
    let contractName = await volcanoContract.name();
    expect(contractName).to.equal("Volcano Coin");
  });

  it("reverts when transferring tokens to the zero address", async () => {
    await expectRevert(
      volcanoContract.transfer(constants.ZERO_ADDRESS, 10),
      "ERC20: transfer to the zero address"
    );
  });

  //homework
  it("has a symbol", async () => {
    let contractSymbol = await volcanoContract.symbol();
    expect(contractSymbol).to.equal("VLC");
  });

  it("has 18 decimals", async () => {
    let contractDecimals = await volcanoContract.decimals();
    expect(contractDecimals).to.equal(18);
  });

  it("assigns initial balance", async () => {
    let contractInitBal = await volcanoContract.totalSupply();
    expect(contractInitBal).to.equal(100000);
  });

  it("increases allowance for address1", async () => {
    let initAllow = await volcanoContract.allowance(owner.address, addr1.address);
    let increaseAllow = 100;
    let finalAllowExp = await initAllow + increaseAllow;
    let txToIncAllow = await volcanoContract.increaseAllowance(addr1.address, increaseAllow);
    await txToIncAllow.wait();
    let finalAllowAct = await volcanoContract.allowance(owner.address, addr1.address);
    expect(finalAllowAct).to.equal(finalAllowExp);
  });

  it("decreases allowance for address1", async () => {
    let txInitAllow = await volcanoContract.increaseAllowance(addr1.address, 1000);
    await txInitAllow.wait()
    let initAllow = await volcanoContract.allowance(owner.address, addr1.address);
    let decreaseAllow = 100;
    let finalAllowExp = await initAllow - decreaseAllow;
    let txToIncAllow = await volcanoContract.decreaseAllowance(addr1.address, decreaseAllow);
    await txToIncAllow.wait();
    let finalAllowAct = await volcanoContract.allowance(owner.address, addr1.address);
    expect(finalAllowAct).to.equal(finalAllowExp);
  });
  
  it("emits an event when increasing allowance", async () => {
    let increaseAllowAmount = 100;
    let txIncreaseAllowance = await volcanoContract.increaseAllowance(addr1.address, increaseAllowAmount);
    await txIncreaseAllowance.wait();
    expect(txIncreaseAllowance).to.emit(volcanoContract, "Approval");
  });

  it("revets decreaseAllowance when trying decrease below 0", async () => {
    await expectRevert(volcanoContract.connect(addr1).decreaseAllowance(addr2.address, 100), "ERC20: decreased allowance below zero");
  });

  it("updates balances on successful transfer from owner to addr1", async () => {
    let initOwnerBalance = await volcanoContract.balanceOf(owner.address);
    let initAddrOneBalance = await volcanoContract.balanceOf(addr1.address);
    let transferAmount = 777;
    let txTransferFromOwnerToAddrOne = await volcanoContract.transfer(addr1.address, transferAmount);
    let finalOwnerBalance = await volcanoContract.balanceOf(owner.address);
    let finalAddrOneBalance = await volcanoContract.balanceOf(addr1.address);
    await txTransferFromOwnerToAddrOne.wait();
    expect(initOwnerBalance - finalOwnerBalance).to.equal(transferAmount);
    expect(finalAddrOneBalance - initAddrOneBalance).to.equal(transferAmount);
  });


  it("revets transfer when sender does not have enough balance", async () => {
    let addrOneBal = await volcanoContract.balanceOf(addr1.address);
    await expectRevert(volcanoContract.connect(addr1).transfer(addr2.address, addrOneBal + 1), "ERC20: transfer amount exceeds balance");
  });

  it("reverts transferFrom addr1 to addr2 called by the owner without setting allowance", async () => {
    let ownerAllowanceForAddr1 = await volcanoContract.allowance(owner.address, addr1.address);
    await expect(volcanoContract.transferFrom(addr1.address, addr2.address, ownerAllowanceForAddr1 + 1 )).to.be.revertedWith("ERC20: transfer amount exceeds balance");
  });

  it("updates balances after transferFrom addr1 to addr2 called by the owner", async () => {
    let transferToAddr1 = 777;
    let txOwnerToAddr1 = await volcanoContract.transfer(addr1.address, transferToAddr1);
    await txOwnerToAddr1.wait();
    let balAddr1Init = await volcanoContract.balanceOf(addr1.address);
    let balAddr2Init = await volcanoContract.balanceOf(addr2.address);
    let transferAddr1ToAddr2 = 200;
    let txTranferAddr1ToAddr2 = await volcanoContract.connect(addr1).transfer(addr2.address, transferAddr1ToAddr2);
    await txTranferAddr1ToAddr2.wait();
    let balAddr1Fin = await volcanoContract.balanceOf(addr1.address);
    let balAddr2Fin = await volcanoContract.balanceOf(addr2.address);
    expect(balAddr1Init - transferAddr1ToAddr2).to.equal(balAddr1Fin);
    expect(balAddr2Init + transferAddr1ToAddr2).to.equal(balAddr2Fin);
  });
});