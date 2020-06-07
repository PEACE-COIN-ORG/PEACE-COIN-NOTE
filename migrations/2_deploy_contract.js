var PeaceCoinNoteToken = artifacts.require('PeaceCoinNoteToken');
module.exports = function(deployer) {
  deployer.deploy(PeaceCoinNoteToken);
};