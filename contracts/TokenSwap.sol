pragma solidity ^0.4.23;

import "./ERC20.sol";
import "../openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "../openzeppelin-solidity/contracts/math/SafeMath.sol";
import "../openzeppelin-soliditycontracts/token/SafeERC20.sol";


contract TokenSwap is Ownable {
    using SafeMath for uint;
    using SafeERC20 for ERC20;

    function exchange(ERC20 fromToken, ERC20 toToken, uint amount) {
        require(fromToken != address(0x0));
        require(toToken != address(0x0));
        // we won't check `amount` for zero because ERC20 implies zero amount transfers as a valid case

        address swapAddress = address(this);
        uint senderFromTokenBalanceBefore = fromToken.balanceOf(msg.sender);
        uint senderToTokenBalanceBefore = toToken.balanceOf(msg.sender);

        uint swapFromTokenBalanceBefore = fromToken.balanceOf(swapAddress);
        uint swapToTokenBalanceBefore = toToken.balanceOf(swapAddress);


        fromToken.safeTransferFrom(msg.sender, address(this), amount);
        toToken.safeTransfer(msg.sender, amount);

        uint senderFromTokenBalanceAfter = fromToken.balanceOf(msg.sender);
        uint senderToTokenBalanceAfter = toToken.balanceOf(msg.sender);

        uint swapFromTokenBalanceAfter = fromToken.balanceOf(swapAddress);
        uint swapToTokenBalanceAfter = toToken.balanceOf(swapAddress);

        assert(senderFromTokenBalanceBefore.sub(amount) == senderFromTokenBalanceAfter);
        assert(senderToTokenBalanceBefore.add(amount) == senderToTokenBalanceAfter);

        assert(swapToTokenBalanceBefore.sub(amount) == swapToTokenBalanceAfter);
        assert(swapFromTokenBalanceBefore.add(amount) == swapFromTokenBalanceAfter);
    }
}
