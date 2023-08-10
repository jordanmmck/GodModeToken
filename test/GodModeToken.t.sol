// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

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

    function testSetGodFail() public {
        vm.expectRevert();
        vm.prank(alice);
        godModeToken.setGod(alice);
    }

    function testSetGodFailZeroAddr() public {
        vm.expectRevert();
        vm.prank(admin);
        godModeToken.setGod(address(0));
    }

    function testMintSuccess() public {
        vm.prank(admin);
        godModeToken.mint(alice, 100);
    }

    function testMintFail() public {
        vm.prank(alice);
        vm.expectRevert();
        godModeToken.mint(alice, 100);
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

    function testNonGodTransferFromSuccess() public {
        vm.prank(bob);
        godModeToken.increaseAllowance(jordan, 1e18);

        vm.prank(jordan);
        godModeToken.transferFrom(bob, jordan, 1e18);
        assertEq(godModeToken.balanceOf(jordan), 1e18);
    }
}
