// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract Fund_FundMe is Script {
    uint256 constant SENT_VALUE = 0.1 ether;

    function fundFundMe(address mostRecentDeployment) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentDeployment)).fund{value: SENT_VALUE}();
        vm.stopBroadcast();
        console.log("Funded FundMe with %s", SENT_VALUE);
    }

    function run() external {
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);

        fundFundMe(mostRecentDeployment);
    }
}

contract Withdraw_FundMe is Script {
    function withdrawFundMe(address mostRecentDeployment) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentDeployment)).withdraw();
        vm.stopBroadcast();
        console.log("Withdraw FundMe balance: ");
    }

    function run() external {
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);

        withdrawFundMe(mostRecentDeployment);
    }
}
