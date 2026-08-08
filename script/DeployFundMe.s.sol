// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    //add return type FundMe to the run function so that we can use the return value in the test script
    function run() external returns (FundMe) {
        HelperConfig helperConfig = new HelperConfig();
        //the memory keyword is used to store the struct in memory instead of storage, so that we can use the struct in the function without modifying the state of the contract
        address ethUsdPriceFeed = helperConfig.activeNetworkConfig();
        //the vm.startBroadcast() function is used to start broadcasting the transaction to the network, so that we can deploy the contract to the network and it also consumes gas.
        vm.startBroadcast();
        //pass the address of the price feed contract to the constructor of the FundMe contract
        FundMe newFundMe = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        return newFundMe;
    }
}
