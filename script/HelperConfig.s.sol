// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mock/MockV3Aggregator.sol";

contract HelperConfig is Script {
    // If we are on local anvil, we deploy mocks
    // Otherwise, grab the existing address from the live network

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 3000e8;

    NetworkConfig public activeNetwork;

    constructor() {
        //Sepolia ETH chain id
        if (block.chainid == 11155111) {
            activeNetwork = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetwork = getEthMainnetConfig();
        } else {
            activeNetwork = getOrCreateAnvilEthConfig();
        }
    }

    struct NetworkConfig {
        address priceFeed; // ETH/USD pricefeed address
    }

    // memory keyword because it is special object
    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        // price feed address
        NetworkConfig memory SepoliaConfig = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return SepoliaConfig;
    }

    function getEthMainnetConfig() public pure returns (NetworkConfig memory) {
        // price feed address
        NetworkConfig memory EthConfig = NetworkConfig({priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
        return EthConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        // price feed address

        // it means that if we have setup mock address once we will
        // not have to create another one
        if (activeNetwork.priceFeed != address(0)) {
            return activeNetwork;
        }

        // Deploy the mocks
        // Return the mock addresses

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        NetworkConfig memory AnvilConfig = NetworkConfig({priceFeed: address(mockPriceFeed)});
        return AnvilConfig;
    }
}

/* 1. Deploy mocks when we are on a local anvil chain
   2. Keep tract of contract address across different chains
*/
