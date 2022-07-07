// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../src/NxNIsland.sol";
import "forge-std/Test.sol";

  // = [
        // [1,0], // expected 3
        // [0,1]

        // [1,1], // expected 4
        // [0,1]

        // [1,1], // expected 4
        // [1,1]

        // [1,1,0,1,0,1], // expected 8
        // [1,0,1,0,0,1],
        // [0,0,1,0,0,1],
        // [1,0,0,1,0,1],
        // [0,0,0,0,0,1],
        // [0,0,0,0,0,1]

        // [1,1,0,1,0,1], // expected 9
        // [1,0,1,0,0,1],
        // [0,0,1,0,0,1],
        // [1,0,0,1,0,0],
        // [0,1,1,1,0,1],
        // [1,1,0,0,0,1]

        // [0,0,1,0,1,0], // expected 3
        // [0,0,0,0,0,0],
        // [0,1,0,1,0,1],
        // [0,0,0,0,0,0],
        // [0,0,1,0,1,0],
        // [1,0,0,0,0,0]

        // [1,1,1,1,1,1,1], // expected 48
        // [1,1,1,1,1,1,1],
        // [1,1,1,1,1,1,1],
        // [1,1,0,1,1,0,1],
        // [1,1,1,1,1,1,1],
        // [1,1,1,1,1,1,1],
        // [1,1,1,1,1,1,1]

        // [1,1,1,1,1,1,1], // expected 49
        // [1,1,1,1,1,1,1],
        // [1,1,1,1,1,1,1],
        // [1,1,1,1,1,1,1],
        // [1,1,1,1,1,1,1],
        // [1,1,1,1,1,1,1],
        // [1,1,1,1,1,1,1]

        // [0,0,0,0,0,0,0], // expected 1
        // [0,0,0,0,0,0,0],
        // [0,0,0,0,0,0,0],
        // [0,0,0,0,0,0,0],
        // [0,0,0,0,0,0,0],
        // [0,0,0,0,0,0,0],
        // [0,0,0,0,0,0,0]
    // ];

contract NxNIslandTest is Test {

    // NxNIsland island;
    function setUp() public {

        // uint8[4][] memory matrix = new uint8[4][](4);
        
        // matrix[0] = [1,0,0,1];
        // matrix[1] = [1,0,0,1];
        // matrix[2] = [1,0,0,1];
        // matrix[3] = [1,0,0,1];

        // island = new NxNIsland(matrix);
    }

    function testAllZeros() public {

        uint8[4][] memory matrix = new uint8[4][](4);
        
        matrix[0] = [0,0,0,0];
        matrix[1] = [0,0,0,0];
        matrix[2] = [0,0,0,0];
        matrix[3] = [0,0,0,0];

        NxNIsland _island = new NxNIsland(matrix, 1);
        uint result = _island.mapIslands();
        assertEq(result, _island.expectedMaxIslandSize());
    }
    function testAllOnes() public {

        uint8[4][] memory matrix = new uint8[4][](4);
        
        matrix[0] = [1,1,1,1];
        matrix[1] = [1,1,1,1];
        matrix[2] = [1,1,1,1];
        matrix[3] = [1,1,1,1];

        NxNIsland _island = new NxNIsland(matrix, 16);
        uint result = _island.mapIslands();
        assertEq(result, _island.expectedMaxIslandSize());
    }
    function testMatrix1() public {

        uint8[4][] memory matrix = new uint8[4][](4);
        
        matrix[0] = [1,0,0,0];
        matrix[1] = [0,0,0,0];
        matrix[2] = [0,0,0,0];
        matrix[3] = [0,0,0,1];

        NxNIsland _island = new NxNIsland(matrix, 2);
        uint result = _island.mapIslands();
        assertEq(result, _island.expectedMaxIslandSize());
    }
}
