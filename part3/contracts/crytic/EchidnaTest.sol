pragma solidity ^0.6.0;

import "./Setup.sol";

contract EchidnaTest is Setup {

    function testProvideLiquidity(uint amount1, uint amount2) public {
        // Pre-conditions:
        amount1 = _between(amount1, 1000, uint(-1));
        amount2 = _between(amount2, 1000, uint(-1));

        if (!completed) {
            _init(amount1, amount2);
        }
        //// State before
        uint lpTokenBalanceBefore = pair.balanceOf(address(user));
        (uint reserve0Before, uint reserve1Before,) = pair.getReserves();
        uint kBefore = reserve0Before * reserve1Before;
        //// Transfer tokens to UniswapV2Pair contract
        (bool success1,) = user.proxy(address(testToken1), abi.encodeWithSelector(testToken1.transfer.selector, address(pair), amount1));
        (bool success2,) = user.proxy(address(testToken2), abi.encodeWithSelector(testToken2.transfer.selector, address(pair), amount2));
        require(success1 && success2);

        // Action:
        (bool success3,) = user.proxy(address(pair), abi.encodeWithSelector(bytes4(keccak256("mint(address)")), address(user)));

        // Post-conditions:
        if (success3) {
            uint lpTokenBalanceAfter = pair.balanceOf(address(user));
            (uint reserve0After, uint reserve1After,) = pair.getReserves();
            uint kAfter = reserve0After * reserve1After;
            assert(lpTokenBalanceBefore < lpTokenBalanceAfter);
            assert(kBefore < kAfter);
        }
    }

    function testBadSwap(uint amount1, uint amount2) public {
        if (!completed) {
            _init(amount1, amount2);
        }

        // Pre-conditions:
        pair.sync();
        require(pair.balanceOf(address(user)) > 0);

        // Action:
        (bool success,) = user.proxy(address(pair), abi.encodeWithSelector(pair.swap.selector, amount1, amount2, address(user), ""));

        // Post-condition:
        assert(!success);
    }
    
    function testSwap(uint amount1, uint amount2) public {
        // Pre-conditions:

        // Action:

        // Post-condition:

    }

}
