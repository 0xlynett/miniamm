// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {IERC20} from "forge-std/interfaces/IERC20.sol";

/// Super basic AMM that uses xy=k in less than 30 SLOC
/// Don't use in production. Not gas optimized. Does not
/// work with rebase tokens. Likely insecure.
/// To add liquidity, simply send tokens to the contract.
contract MiniAMM {
    mapping(bool => address) public toks;
    constructor(address ta, address tb) {
        (toks[true], toks[false]) = (ta, tb);
    }
    function swap(bool toka, uint256 tin) public {
        require(
            IERC20(toks[toka]).transferFrom(msg.sender, address(this), tin)
        );
        IERC20(toks[!toka]).transfer(msg.sender, getOut(toka, tin));
    }
    function getOut(bool toka, uint256 tin) public view returns (uint256) {
        return
            (tin * IERC20(toks[!toka]).balanceOf(address(this))) /
            IERC20(toks[toka]).balanceOf(address(this));
    }
}
