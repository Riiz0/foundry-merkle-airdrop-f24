// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract MerkleAirdrop {
    using SafeERC20 for IERC20;

    error MerkleAirdrop__InvalidMerkleProof();
    error MerkleAirdrop__AlreadyClaimed();

    bytes32 private immutable i_merkleProof;
    IERC20 private immutable i_airdropToken;

    mapping(address claimer => bool claimed) private s_hasClaimed;

    event Claim(address indexed account, uint256 indexed amount);

    constructor(bytes32 merkleProof, IERC20 airdropToken) {
        i_airdropToken = airdropToken;
        i_merkleProof = merkleProof;
    }

    function claim(address account, uint256 amount, bytes32[] calldata merkleProof) external {
        if (!s_hasClaimed[account]) {
            revert MerkleAirdrop__AlreadyClaimed();
        }
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account, amount))));
        if (!MerkleProof.verify(merkleProof, i_merkleProof, leaf)) {
            revert MerkleAirdrop__InvalidMerkleProof();
        }
        s_hasClaimed[account] = true;
        i_airdropToken.safeTransfer(account, amount);

        emit Claim(account, amount);
    }

    function getMerkelRoot() public view returns (bytes32) {
        return i_merkleProof;
    }

    function getAirdropToken() public view returns (IERC20) {
        return i_airdropToken;
    }

    function getHasClaimed(address account) public view returns (bool) {
        return s_hasClaimed[account];
    }
}
