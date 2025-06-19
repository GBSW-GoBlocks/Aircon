const Aircon = artifacts.require("Aircon");

module.exports = function (deployer, network, accounts) {
  const admin = accounts[0];
  const initTemp = 22;
  const defaultMode = 0;

  deployer.deploy(Aircon, admin, initTemp, defaultMode);
};
