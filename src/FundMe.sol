// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

error FundMe__notOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MIN_USD = 5e18;

    address[] private s_funders;

    address private immutable i_owner;

    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    mapping(address funders => uint256 amountFunded) private s_addressToAmountFunded;

    function fund() public payable {
        // function to allow users to send funds
        // lets say min 5$

        require(msg.value.getConversionRate(s_priceFeed) >= MIN_USD, "You did'nt send enough ETH");
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] = s_addressToAmountFunded[msg.sender] + msg.value;
        // 1 Ether = 10 ** 18 wei
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    function cheaperWithdraw() public onlyOwner {
        uint256 fundersLength = s_funders.length;

        for (uint256 funderIndex = 0; funderIndex < fundersLength; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        // resetting array
        s_funders = new address[](0);

        // call
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed!");
    }

    function withdraw() public onlyOwner {
        // resetting mapping
        for (uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        // resetting array
        s_funders = new address[](0);

        /* (03) ways to send: 
        transfer: gas limit 2300, automatically reverts the transaction
        send: gas limit 2300, returns boolean(true or false) to indicate if transfer was successfull
        call: forwards all gas or gas set (no limit), alse returns boolean

        => transfer
        payable(msg.sender).transfer(address(this).balance);

        => send
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        require(sendSuccess, "Send failed!");
        */

        // call
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed!");
    }

    modifier onlyOwner() {
        //require(msg.sender == i_owner, "not owner!");
        if (msg.sender != i_owner) revert FundMe__notOwner();
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    // view / pure functions (Getters)

    function getAddressToAmmountFunded(address fundingAddress) external view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getFunders(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }
}

// not constant - 2512 gas        constant - 303 gas
// not immutable - 2552 gas       immutable -424 gas
