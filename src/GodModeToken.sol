// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title A token with "God mode" that allows the special admin to transfer tokens from any address
/// @author Jordan McKinney
/// @notice ERC20 token with an admin that can transfer tokens from any address
/// @dev This is a test contract and should not be used in production
contract GodModeToken is ERC20 {
    address public immutable admin;
    address public god;

    constructor() ERC20("GodModeToken", "GMT") {
        admin = msg.sender;
    }

    function setGod(address newGod) public {
        require(msg.sender == admin || msg.sender == god, "only admin/god can set god");
        require(newGod != address(0), "god cannot be zero address");
        god = newGod;
    }

    function mint(address to, uint256 amount) public {
        require(msg.sender == admin, "only admin");
        _mint(to, amount);
    }

    function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
        if (msg.sender == god) {
            _transfer(from, to, amount);
        } else {
            address spender = _msgSender();
            _spendAllowance(from, spender, amount);
            _transfer(from, to, amount);
        }
        return true;
    }
}
