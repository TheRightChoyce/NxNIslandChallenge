// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/ds-test/src/test.sol";
import "../src/NxNIsland.sol";

contract NxNIslandTest is DSTest {

    NxNIsland nXNIsland;
    function setUp() public {
        emit log("setUp");
        nXNIsland = new NxNIsland();
    }

    function testExample() public {
        assertTrue(true);
    }

    function testGetArea() public {
        uint result = nXNIsland.getArea();
        
        assertTrue(result == 0);
    }
}
