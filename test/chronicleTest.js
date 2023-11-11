const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

const { ethers } = require("hardhat");

describe("Chronicle Contract", function () {
  let Chronicle;
  let chronicle;
  let owner;
  let addr1;
  let addr2;

  beforeEach(async function () {
    Chronicle = await ethers.getContractFactory("Chronicle");
    [owner, addr1, addr2] = await ethers.getSigners();
    chronicle = await Chronicle.deploy();
  });


  describe("registerCar", function () {
    it("Should register a car successfully", async function () {
      const vin = "1HGCM82633A004352";
      await expect(chronicle.registerCar(vin, addr1.address))
        .to.emit(chronicle, "CarRegistered")
        .withArgs(vin, addr1.address);
    });

    it("Should fail to register a car that's already registered", async function () {
      const vin = "1HGCM82633A004352";
      await chronicle.registerCar(vin, addr1.address);

      await expect(chronicle.registerCar(vin, addr1.address)).to.be.revertedWith("Car already registered");
    });
  });


  describe("updateCarHistory", function () {
    it("Should update car history successfully", async function () {
      await chronicle.connect(addr1).registerCar("VIN123", addr1.address);
      await chronicle.connect(addr1).updateCarHistory("VIN123", 50, 60000, 30);
      const carHistory = await chronicle.getCarHistory("VIN123");
      expect(carHistory.engineLoad).to.equal(50);
      expect(carHistory.distanceWithMilage).to.equal(60000);
      expect(carHistory.throttlePosition).to.equal(30);
    });

    it("Should not allow a non-owner to update car history", async function () {
      const vin = "1HGBH41JXMN109186";
      await chronicle.registerCar(vin, owner.address);
      await expect(chronicle.connect(addr1).updateCarHistory(vin, 40, 20000, 30))
        .to.be.revertedWith("Is not the owner");
    });
  });

  describe("transferOwnership", function () {
    it("Should transfer ownership successfully", async function () {
      const vin = "1HGBH41JXMN109186";
      await chronicle.registerCar(vin, owner.address);
      await chronicle.transferOwnership(vin, addr1.address);

      const carHistory = await chronicle.getCarHistory(vin);
      expect(carHistory.ownershipChanges[0].toLowerCase()).to.equal(addr1.address.toLowerCase());
    });
  });

  describe("getCarHistory", function () {
    it("Should retrieve car history correctly", async function () {
      const vin = "1HGBH41JXMN109186";
      await chronicle.registerCar(vin, owner.address);
      await chronicle.updateCarHistory(vin, "50", "30000", "40");
      const carHistory = await chronicle.getCarHistory(vin);

      expect(carHistory.engineLoad).to.equal("50");
      expect(carHistory.distanceWithMilage).to.equal("30000");
      expect(carHistory.throttlePosition).to.equal("40");
    });
  });

  describe("evaluateCar", function () {
    it("Should evaluate the car correctly", async function () {
      await chronicle.connect(addr1).registerCar("VIN123", addr1.address);
      await chronicle.connect(addr1).updateCarHistory("VIN123", 50, 60000, 30);
      const evaluation = await chronicle.evaluateCar("VIN123");
      expect(evaluation).to.equal(1);
    });
  });

});


