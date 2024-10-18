// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script, console2} from "forge-std/Script.sol";
import {MerkleAirdrop} from "src/MerkleAirdrop.sol";
import {BagelToken} from "src/BagelToken.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract DeployMerkleAirdrop is Script {
    bytes32 private s_merkleRoot = 0xc749190f6b6109cdf86c8855003b9bcf8b20f2f7bc6249f7066c2a71795120ba;
    uint256 s_amountToTransfer = 4 * (25 * 1e18);

    function deployMerkleAirdrop() public returns (MerkleAirdrop, BagelToken) {
        vm.startBroadcast();

        BagelToken bagelToken = new BagelToken();
        MerkleAirdrop merkleAirdrop = new MerkleAirdrop(s_merkleRoot, IERC20(address(bagelToken)));
        bagelToken.mint(bagelToken.owner(), s_amountToTransfer);
        bagelToken.transfer(address(merkleAirdrop), s_amountToTransfer);
        vm.stopBroadcast();
    }

    function run() external returns (MerkleAirdrop, BagelToken) {
        return deployMerkleAirdrop();
    }
}
