// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.6.12;

import "@dynamic-amm/smart-contracts/contracts/interfaces/IDMMRouter02.sol";
import "@dynamic-amm/smart-contracts/contracts/interfaces/IDMMFactory.sol";


contract Pool {
    IDMMRouter02 public dmmRouter;
    IDMMFactory public dmmFactory;
    IERC20 public usdt = 0xdac17f958d2ee523a2206206994597c13d831ec7; // mainnet USDT address
    IERC20 public dai = 0x6b175474e89094c44da98b954eedeac495271d0f; // mainnet DAI address
    IERC20[] public tokensPath = [usdt,dai];

    constructor(IDMMRouter02 _dmmRouter) {
        dmmRouter = _dmmRouter;
        dmmFactory = IDMMFactory(dmmRouter.factory());
    }

    // the first (and our recommended) method is to 
    // query for the best pool off-chain and pass it as an input
    function getRateFirstMethod(address[] poolsPath) external view returns (uint256[] amounts) {
        // return amounts
        return dmmRouter.getAmountsIn(
            1e20, // 100 DAI
            poolsPath,
            tokensPath
        );
    }
    
    // the second method is to use the unamplified pool
    // while convenient, it may not be optimal
    function getRateSecondMethod() external view returns (uint256[] amounts) {
        address poolAddress = dmmFactory.getUnamplifiedPool(usdt, dai);

        // use unamplified pool
        addresss[] memory poolsPath = new address[](1);
        poolsPath[0] = poolAddress;

        // return amounts
        return dmmRouter.getAmountsIn(
            1e20, // 100 DAI
            poolPath,
            tokensPath
        );
    }

    // the third method is to use the pool found in the first index of the pool array
    // if no pools are available, return empty array
    function getRateThirdMethod() external view returns (uint256[] amounts) {
        address[] memory poolAddresses = dmmFactory.getPools(usdt, dai);
        if (poolAddresses.length == 0) return;

        // use the pool address of the first index of the pool array
        addresss[] memory poolsPath = new address[](1);
        poolsPath[0] = poolAddresses[0];

        // return amounts
        return dmmRouter.getAmountsIn(
            1e20, // 100 DAI
            poolPath,
            tokensPath
        );
    }
}