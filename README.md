# MiniAMM

Super simple AMM implementation in 17 lines of code.

```ts
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
```
