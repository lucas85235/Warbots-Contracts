const Robot = artifacts.require("Robot");
const Part = artifacts.require("Part");

module.exports = function (deployer) {
  deployer.deploy(Part);
  deployer.deploy(Robot, "0x48DbF3D51B8519400556dF64F7cb1A6E3B9AE4f2");
};
