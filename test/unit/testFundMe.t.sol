// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    address USER = makeAddr("me"); // creating a fake address
    uint256 public constant SENT_VALUE = 0.1 ether; // 100000000000000000
    uint256 public constant INITIAL_BALANCE = 10 ether;

    function setUp() external {
        //us -> FundMeTest -> FundMe
        //fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, INITIAL_BALANCE); // giving fake user fake balance
    }

    function testMinUSDIsFive() public {
        assertEq(fundMe.MIN_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVersionIsCorrect() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughEth() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testcheckIfFundsUpdateFundedDS() public {
        vm.prank(USER); // The next TX will be sent by the fake user we created
        fundMe.fund{value: SENT_VALUE}();

        uint256 amountFunded = fundMe.getAddressToAmmountFunded(USER);
        assertEq(amountFunded, SENT_VALUE);
    }

    function testAddFundersToArrayOfFunders() public {
        vm.prank(USER);
        fundMe.fund{value: SENT_VALUE}();

        assertEq(fundMe.getFunders(0), USER);
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SENT_VALUE}();
        _;
    }

    function testWithdrawWithSingleFunder() public funded {
        // Arrange
        // check first what is the current balance of owner and contract

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        // Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);
    }

    function testcheaperWithdrawWithMultipleFunders() public {
        uint160 numberOfFunders = 10;
        // uint160 to typecast from uint to address
        uint160 startingFunderIndex = 1;

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            /*vm.prank new address
             vm.deal new address
             address
             hoax does the work of both vm.prank and vm.deal */
            hoax(address(i), SENT_VALUE);
            fundMe.fund{value: SENT_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.startPrank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        vm.stopPrank();

        // Assert

        assert(address(fundMe).balance == 0);
        assert(startingOwnerBalance + startingFundMeBalance == fundMe.getOwner().balance);
    }

    function testWithdrawWithMultipleFunders() public {
        uint160 numberOfFunders = 10;
        // uint160 to typecast from uint to address
        uint160 startingFunderIndex = 1;

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            /*vm.prank new address
             vm.deal new address
             address
             hoax does the work of both vm.prank and vm.deal */
            hoax(address(i), SENT_VALUE);
            fundMe.fund{value: SENT_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        // Assert

        assert(address(fundMe).balance == 0);
        assert(startingOwnerBalance + startingFundMeBalance == fundMe.getOwner().balance);
    }
}
