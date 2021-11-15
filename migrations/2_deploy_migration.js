const Robot = artifacts.require("Robot");
const Part = artifacts.require("Part");

module.exports = function (deployer) {
  deployer.deploy(Part).then(() => deployer.deploy(Robot, Part.address));
};
