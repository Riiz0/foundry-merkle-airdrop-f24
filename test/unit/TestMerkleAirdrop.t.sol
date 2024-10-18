// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Test, console2} from "forge-std/Test.sol";
import {MerkleAirdrop} from "src/MerkleAirdrop.sol";
import {BagelToken} from "src/BagelToken.sol";

contract TestMerkleAirdrop is Test {
    MerkleAirdrop merkleAirdrop;
    BagelToken bagelToken;

    bytes32 public ROOT = 0xc749190f6b6109cdf86c8855003b9bcf8b20f2f7bc6249f7066c2a71795120ba;
    uint256 public AMOUNT_TO_CLAIM = 25 * 1e18;
    uint256 public AMOUNT_TO_SEND = AMOUNT_TO_CLAIM * 4;
    bytes32 proofOne = 0x0fd7c981d39bece61f7499702bf59b3114a90e66b51ba2c53abdf7b62986c00a;
    bytes32 proofTwo = 0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;
    bytes32[] public PROOF = [proofOne, proofTwo];
    address user;
    uint256 userPrivKey;

    function setUp() public {
        bagelToken = new BagelToken();
        merkleAirdrop = new MerkleAirdrop(ROOT, bagelToken);
        bagelToken.mint(bagelToken.owner(), AMOUNT_TO_SEND);
        bagelToken.transfer(address(merkleAirdrop), AMOUNT_TO_SEND);
        (user, userPrivKey) = makeAddrAndKey("users");
    }

    function testUsersCanClaim() public {
        uint256 startingBalance = bagelToken.balanceOf(user);
        vm.prank(user);
        merkleAirdrop.claim(user, AMOUNT_TO_CLAIM, PROOF);

        uint256 endingBalance = bagelToken.balanceOf(user);
        console2.log("Ending balance: ", endingBalance);

        assertEq(endingBalance - startingBalance, AMOUNT_TO_CLAIM);
    }
}
