// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../src/NxNIsland.sol";
import "forge-std/Test.sol";

contract NxNIslandTest is Test {

    NxNIsland island;
    function setUp() public {
        emit log("setUp");
        island = new NxNIsland();
    }

    // function testGetArea() public {
    //     uint result = nXNIsland.getArea(testMatrix);
    //     assertTrue(result == 0);
    // }

    function testContract() public {
        uint result = island.CalculateIsland();
        assertEq(0, result);
    }
}
