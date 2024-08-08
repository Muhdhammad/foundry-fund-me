// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        // Before startBroadcast -> not a real TX
        HelperConfig helperConfig = new HelperConfig();
        address ethUSDPriceFeed = helperConfig.activeNetwork();

        // After startBroadcast -> real TX
        vm.startBroadcast();
        FundMe fundMe = new FundMe(ethUSDPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}
