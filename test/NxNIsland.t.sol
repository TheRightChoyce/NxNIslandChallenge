// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../src/NxNIsland.sol";
import "forge-std/Test.sol";

contract NxNIslandTest is Test {

    NxNIsland island;
    function setUp() public {
        island = new NxNIsland();
    }
    function testMapIslands() public {        
        uint result = island.mapIslands();

        console.log("");
        console.log("Longest island:");
        island.logLongestIsland();
        
        assertEq(result, island.getExpectedMaxIslandSize());    
    }
}
