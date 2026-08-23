// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    //make mock user address to test the fund function, so that we can test the fund function without using the owner address
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 10;

    function setUp() external {
        //use deployfundme instead of deploying new here, so that we can use the same deploy script for both testing and deployment
        DeployFundMe deployFundMe = new DeployFundMe();
        //use the run function to deploy the contract and get the address of the deployed contract
        fundMe = deployFundMe.run();
        //set the balance of the mock user address to 10 ether, so that we can test the fund function without running out of ether
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumUsdIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughEth() public {
        vm.expectRevert();
        //value 1 is not enough to fund, because the minimum is 5 USD, and 1 wei is less than 5 USD
        //the minimum value in wei that is required to fund is 5 USD / price of ETH in USD, which is 5e18 / price of ETH in USD
        //example if eth price is 2000 USD, then the minimum value in wei that is required to fund is 5e18 / 2000e18 = 2.5e15 wei
        fundMe.fund{value: 1}();
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawWithASingleFunder() public funded {
        //arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        //assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);
    }

    function testWithdrawFromMultipleFunders() public funded {
        //arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;

        for (uint160 i = startingFunderIndex; i < numberOfFunders + startingFunderIndex; i++) {
            //hoax is a combination of vm.prank and vm.deal, it sets the msg.sender to the address and also sets the balance of the address to the value, so that we can use the address to fund the contract without running out of ether
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //act
        // uint256 gasStart = gasleft();
        //set the gas price to 1000 gwei, so that we can simulate the gas cost of the transaction, and we can use it to calculate the gas cost of the transaction, so that we can assert that the gas cost is less than the starting balance of the owner, so that we can assert that the owner has enough ether to pay for the gas cost of the transaction
        // vm.txGasPrice(GAS_PRICE);
        //startPrank is the same as prank, but in between startPrank and stopPrank, all the transactions will be sent from the address, so that we can execute multiple transactions from the same address without having to call prank multiple times, and it also saves gas because we don't have to set the msg.sender multiple times
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        // uint256 gasEnd = gasleft();
        // uint256 gasUsed = gasStart - gasEnd;
        // uint256 gasCost = gasUsed * tx.gasprice;

        //assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(
            startingFundMeBalance + startingOwnerBalance,
            endingOwnerBalance //+ gasCost
        );
    }

    function testWithdrawFromMultipleFundersCheaper() public funded {
        //arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;

        for (uint160 i = startingFunderIndex; i < numberOfFunders + startingFunderIndex; i++) {
            //hoax is a combination of vm.prank and vm.deal, it sets the msg.sender to the address and also sets the balance of the address to the value, so that we can use the address to fund the contract without running out of ether
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //act
        // uint256 gasStart = gasleft();
        //set the gas price to 1000 gwei, so that we can simulate the gas cost of the transaction, and we can use it to calculate the gas cost of the transaction, so that we can assert that the gas cost is less than the starting balance of the owner, so that we can assert that the owner has enough ether to pay for the gas cost of the transaction
        // vm.txGasPrice(GAS_PRICE);
        //startPrank is the same as prank, but in between startPrank and stopPrank, all the transactions will be sent from the address, so that we can execute multiple transactions from the same address without having to call prank multiple times, and it also saves gas because we don't have to set the msg.sender multiple times
        vm.startPrank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        vm.stopPrank();

        // uint256 gasEnd = gasleft();
        // uint256 gasUsed = gasStart - gasEnd;
        // uint256 gasCost = gasUsed * tx.gasprice;

        //assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(
            startingFundMeBalance + startingOwnerBalance,
            endingOwnerBalance ////+ gasCost
        );
    }
}

