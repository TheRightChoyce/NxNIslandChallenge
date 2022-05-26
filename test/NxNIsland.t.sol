// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../src/NxNIsland.sol";
import "forge-std/Test.sol";

contract NxNIslandTest is Test {

    NxNIsland island;
    function setUp() public {
        // emit log("setUp");
        island = new NxNIsland();
    }

    // function testGetArea() public {
    //     uint result = nXNIsland.getArea(testMatrix);
    //     assertTrue(result == 0);
    // }

    function testContract() public {
        uint result = island.CalculateIsland();
        assertEq(result, island.getExpectedMaxIslandSize());
        
        // uint8[][] memory matrix = island.getMatrix();
        // emit log_uint(matrix[0][0]);
        // emit log_uint(matrix[0][1]);
        // emit log_uint(matrix[0][2]);
        // emit log_uint(matrix[1][0]);
        // emit log_uint(matrix[1][1]);
        // emit log_uint(matrix[1][2]);        
    }
}
