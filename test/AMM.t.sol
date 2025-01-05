// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {ERC20} from "solady/src/tokens/ERC20.sol";
import {MiniAMM} from "src/AMM.sol";

contract TestERC20 is ERC20 {
    function name() public pure override returns (string memory) {
        return "";
    }
    function symbol() public pure override returns (string memory) {
        return "";
    }
    function mint(address recv, uint256 amt) public {
        _mint(recv, amt);
    }
}

contract CounterTest is Test {
    MiniAMM public amm;
    TestERC20 public tok1;
    TestERC20 public tok2;

    function setUp() public {
        (tok1, tok2) = (new TestERC20(), new TestERC20());
        amm = new MiniAMM(address(tok1), address(tok2));

        // Donate some tokens for liquidity
        tok1.mint(address(amm), 1 ether);
        tok2.mint(address(amm), 1 ether);
    }

    function testSwap(uint256 x) public {
        x = bound(x, 1, 1000 ether);

        tok1.mint(address(this), x);
        tok1.approve(address(amm), x);

        uint256 kLast = tok1.balanceOf(address(amm)) *
            tok2.balanceOf(address(amm));

        amm.swap(true, x);

        // verify xy=k
        uint256 kAfter = tok1.balanceOf(address(amm)) *
            tok2.balanceOf(address(amm));
        assertApproxEqRel(kLast, kAfter, 1e15);
    }
}
