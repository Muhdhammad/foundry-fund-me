// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

// For ABI interfaces
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

// library can't have any state variables
// all functions are marked as internal

library PriceConverter {
    function getPrice(AggregatorV3Interface priceFeed) internal view returns (uint256) {
        // 1. Address : ETH/USD on Sepolia testnet
        // 2. ABI

        (, int256 answer,,,) = priceFeed.latestRoundData(); // only need answer i.e price
        // Price of Eth in USD
        // 320000000000
        // answer multiplied by 1e10 to match 18 decimal places of msg.value whereas answer has 8

        return uint256(answer * 1e10); // typecasting because msg.value is uint256 and price is int256
    }

    function getConversionRate(uint256 ethAmount, AggregatorV3Interface priceFeed) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        // 1 eth = 1_000000000000000000
        // 3200_000000000000000000
        uint256 ethAmountinUSD = (ethAmount * ethPrice) / 1e18;
        // (1_000000000000000000 * 3200_000000000000000000)/1e18 = 3200_000000000000000000
        return ethAmountinUSD;
    }
}
