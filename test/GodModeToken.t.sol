// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/GodModeToken.sol";

contract GodModeTokenTest is Test {
    GodModeToken public godModeToken;
    address public admin = address(0x0);
    address public alice = address(0x1);
    address public bob = address(0x2);
    address public jordan = address(0x3);

    function setUp() public {
        vm.prank(admin);
        godModeToken = new GodModeToken();

        vm.prank(admin);
        godModeToken.mint(bob, 1e18);
    }

    function testSetGod() public {
        vm.prank(admin);
        godModeToken.setGod(alice);
        assertEq(godModeToken.god(), alice);
    }

    function testGodTransferFrom() public {
        vm.prank(admin);
        godModeToken.setGod(alice);

        vm.prank(alice);
        godModeToken.transferFrom(bob, jordan, 1e18);
        assertEq(godModeToken.balanceOf(jordan), 1e18);
    }

    function testGodTransferFromFail() public {
        vm.prank(admin);
        godModeToken.setGod(alice);

        vm.prank(jordan);
        vm.expectRevert();
        godModeToken.transferFrom(bob, jordan, 1e18);
    }
}
