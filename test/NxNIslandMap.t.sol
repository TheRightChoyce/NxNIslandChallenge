// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../src/NxNIslandMap.sol";
import "forge-std/Test.sol";


contract NxNIslandMapTest is Test {

    // NxNIsland island;
    function setUp() public {
    }

    function testPushElement() public {

        uint8[16] memory matrix = [
            1,0,0,0, // row 0
            0,1,0,0, // row 2
            0,0,1,0, // row 3
            0,0,0,1 // row 4
        ];
        uint cols = 4;
        uint rows = matrix.length / cols;
        
        NxNIslandMap _island = new NxNIslandMap(cols);

        for (uint i = 0; i < rows; i++) {

            for (uint j = 0; j < cols; j++) {
                _island.pushElement(i, matrix[(i * cols) + j]);
            }
        }

        assertEq( matrix.length, _island.getMatrixLength() );
        assertEq( matrix[0], _island.getMatrixValue(0, 0) );
        assertEq( matrix[1], _island.getMatrixValue(0, 1) );
        assertEq( matrix[5], _island.getMatrixValue(1, 1) );
        assertEq( matrix[10], _island.getMatrixValue(2, 2) );
        assertEq( matrix[15], _island.getMatrixValue(3, 3) );
    }
}
