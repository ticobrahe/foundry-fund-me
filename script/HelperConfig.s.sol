// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script{

    uint8 public constant DECIMAL = 8;
    int256 public constant INITIAL_PRICE = 200e18;
    struct NetworkConfig {
        address priceFeed;
    }

    NetworkConfig public activeNetwork;
    constructor(){
        if(block.chainid == 11155111){
            activeNetwork = getSepoliaNetwork();
        }
        else {
            activeNetwork = getOrCreateAnvilEthConfgi();
        }
    }

    function getSepoliaNetwork() public pure returns(NetworkConfig memory){
        return  NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306 });
    }
    
    function getOrCreateAnvilEthConfgi() public returns(NetworkConfig memory){
        if (activeNetwork.priceFeed != address(0)) {
            return activeNetwork;
        }
        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(DECIMAL, INITIAL_PRICE);
        vm.stopBroadcast();
        return  NetworkConfig({priceFeed: address(mockV3Aggregator) });
    }
}