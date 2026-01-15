// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "forge-std/Test.sol";
import "../contracts/Stake.sol";

contract StakeTest is Test {
    Stake public stakeToken;
    address public owner;
    address public user1;
    address public user2;

    function setUp() public {
        owner = address(this); // testowy owner
        user1 = address(0x1);
        user2 = address(0x2);

        stakeToken = new Stake();

        // Upewniamy się, że user1 i user2 mają trochę tokenów
        stakeToken.mint(user1, 1000 * 10**stakeToken.decimals());
        stakeToken.mint(user2, 1000 * 10**stakeToken.decimals());
    }

    function testInitialBalance() public {
        uint256 ownerBalance = stakeToken.balanceOf(owner);
        assertEq(ownerBalance, 10000 * 10**stakeToken.decimals() - 1000*2*10**stakeToken.decimals());
    }

    function testPauseUnpause() public {
        stakeToken.pause();
        vm.expectRevert(); // gdy kontrakt paused, transfery nie powinny działać
        stakeToken.transfer(user1, 1);

        stakeToken.unpause();
        stakeToken.transfer(user1, 1);
        assertEq(stakeToken.balanceOf(user1), 1000 * 10**stakeToken.decimals() + 1);
    }

    function testStakeAndWithdraw() public {
        // Przygotowanie tokenów user1
        vm.startPrank(user1);
        stakeToken.approve(address(stakeToken), 500 * 10**stakeToken.decimals());
        stakeToken.stake(500 * 10**stakeToken.decimals());

        assertEq(stakeToken.stakingBalance(user1), 500 * 10**stakeToken.decimals());
        assertTrue(stakeToken.isCurrentlyStaking(user1));

        // Wycofanie
        stakeToken.withdrawStakedTokens();
        assertEq(stakeToken.stakingBalance(user1), 0);
        assertFalse(stakeToken.isCurrentlyStaking(user1));
        vm.stopPrank();
    }

    function testHandOutAwards() public {
        // user1 i user2 stake
        vm.startPrank(user1);
        stakeToken.approve(address(stakeToken), 500 * 10**stakeToken.decimals());
        stakeToken.stake(500 * 10**stakeToken.decimals());
        vm.stopPrank();

        vm.startPrank(user2);
        stakeToken.approve(address(stakeToken), 200 * 10**stakeToken.decimals());
        stakeToken.stake(200 * 10**stakeToken.decimals());
        vm.stopPrank();

        stakeToken.setInterestRate(10); // 10%
        stakeToken.handOutAwards();

        uint256 reward1 = 500 * 10**stakeToken.decimals() + 500 * 10**stakeToken.decimals() / 10;
        uint256 reward2 = 200 * 10**stakeToken.decimals() + 200 * 10**stakeToken.decimals() / 10;

        assertEq(stakeToken.stakingBalance(user1), reward1);
        assertEq(stakeToken.stakingBalance(user2), reward2);
    }

    function testOnlyOwnerFunctions() public {
        // Tylko owner może mintować
        vm.startPrank(user1);
        vm.expectRevert();
        stakeToken.mint(user1, 100);
        vm.stopPrank();

        // Owner może mintować
        stakeToken.mint(user1, 100);
        assertEq(stakeToken.balanceOf(user1), 1000 * 10**stakeToken.decimals() + 100);
    }
}
