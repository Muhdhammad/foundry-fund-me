// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {Fund_FundMe, Withdraw_FundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    FundMe fundMe;

    address USER = makeAddr("me"); // creating a fake address
    uint256 public constant SENT_VALUE = 0.1 ether; // 100000000000000000
    uint256 public constant INITIAL_BALANCE = 10 ether;

    function setUp() external {
        //us -> FundMeTest -> FundMe
        //fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deploy = new DeployFundMe();
        fundMe = deploy.run();
        vm.prank(USER);
        vm.deal(USER, 1e18); // giving fake user fake balance
    }

    function testUserCanFundInteractions() public {
        Fund_FundMe fundFundMe = new Fund_FundMe();
        fundFundMe.fundFundMe(address(fundMe));

        Withdraw_FundMe withdrawFundMe = new Withdraw_FundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assert(address(fundMe).balance == 0);
    }
}
