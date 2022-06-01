// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../src/NxNIslandMap.sol";
import "forge-std/Test.sol";


contract NxNIslandMapTest is Test {

    // NxNIsland island;
    function setUp() public {
    }

    function testConstructor() public {
        uint8[] memory matrix = new uint8[](256);

        matrix[0] = 1;
        matrix[5] = 1;
        matrix[10] = 1;
        matrix[15] = 1; 
        // [
        //     1,0,0,0, // row 0
        //     0,1,0,0, // row 2
        //     0,0,1,0, // row 3
        //     0,0,0,1 // row 4
        // ];
        
        uint8 n = 4;
        NxNIslandMap _island = new NxNIslandMap(n, n, matrix);
        
        assertEq( n * n, _island.getMatrixLength() );
        assertEq( matrix[0], _island.getMatrixValue(0, 0) );
        assertEq( matrix[1], _island.getMatrixValue(0, 1) );
        assertEq( matrix[5], _island.getMatrixValue(1, 1) );
        assertEq( matrix[10], _island.getMatrixValue(2, 2) );
        assertEq( matrix[15], _island.getMatrixValue(3, 3) );
    }
    function testPushElement() public {

        uint8[16] memory matrix = [
            1,0,0,0, // row 0
            0,1,0,0, // row 2
            0,0,1,0, // row 3
            0,0,0,1 // row 4
        ];
        uint8 n = 4;
        uint rows = matrix.length / n;
        
        NxNIslandMap _island = new NxNIslandMap(n, n, new uint8[](0));

        for (uint i = 0; i < rows; i++) {

            for (uint j = 0; j < n; j++) {
                _island.pushElement(i, matrix[(i * n) + j]);
            }
        }

        assertEq( matrix.length, _island.getMatrixLength() );
        assertEq( matrix[0], _island.getMatrixValue(0, 0) );
        assertEq( matrix[1], _island.getMatrixValue(0, 1) );
        assertEq( matrix[5], _island.getMatrixValue(1, 1) );
        assertEq( matrix[10], _island.getMatrixValue(2, 2) );
        assertEq( matrix[15], _island.getMatrixValue(3, 3) );
    }
    function testPushRow() public {

        uint8[16] memory matrix = [
            1,0,0,0, // row 0
            0,1,0,0, // row 2
            0,0,1,0, // row 3
            0,0,0,1 // row 4
        ];
        uint8 n = 4;
        uint rows = matrix.length / n;
        
        NxNIslandMap _island = new NxNIslandMap(n, n, new uint8[](0));

        for (uint i = 0; i < rows; i++) {

            uint8[] memory row = new uint8[](n);

            for (uint j = 0; j < n; j++) {
                row[j] = matrix[(i * n) + j];
            }
            _island.pushRow(i, row);
        }

        assertEq( matrix.length, _island.getMatrixLength() );
        assertEq( matrix[0], _island.getMatrixValue(0, 0) );
        assertEq( matrix[1], _island.getMatrixValue(0, 1) );
        assertEq( matrix[5], _island.getMatrixValue(1, 1) );
        assertEq( matrix[10], _island.getMatrixValue(2, 2) );
        assertEq( matrix[15], _island.getMatrixValue(3, 3) );
    }
}
