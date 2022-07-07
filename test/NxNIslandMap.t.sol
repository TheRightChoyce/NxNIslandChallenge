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
        
        assertEq( n * n, _island.matrixLength() );
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

        assertEq( matrix.length, _island.matrixLength() );
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

        assertEq( matrix.length, _island.matrixLength() );
        assertEq( matrix[0], _island.getMatrixValue(0, 0) );
        assertEq( matrix[1], _island.getMatrixValue(0, 1) );
        assertEq( matrix[5], _island.getMatrixValue(1, 1) );
        assertEq( matrix[10], _island.getMatrixValue(2, 2) );
        assertEq( matrix[15], _island.getMatrixValue(3, 3) );
    }

    function testAllOnes() public {

        uint8[] memory matrix = new uint8[](256);        
        uint8 n = 4;
        for (uint8 i = 0; i < 16; i++ ) {
            matrix[i] = uint8(1);
        }
        NxNIslandMap _island = new NxNIslandMap(n, n, matrix);

        uint result = _island.mapIslands();
        assertEq(result, 16);
    }
    function testAllZeros() public {

        uint8[] memory matrix = new uint8[](256);        
        uint8 n = 4;
        NxNIslandMap _island = new NxNIslandMap(n, n, matrix);

        uint result = _island.mapIslands();
        assertEq(result, 1);
    }
    function test7x7Array() public {

        uint8[] memory m = new uint8[](256);        
        uint8 n = 7;
        
        // test a 7 x 7 matrix with two zeros.. the result should be 48
        // [1,1,1,1,1,1,1],
        m[0] = 1; m[1] = 1; m[2] = 1; m[3] = 1; m[4] = 1; m[5] = 1; m[6] = 1;
        // [1,1,1,1,1,1,1],
        m[7] = 1; m[8] = 1; m[9] = 1; m[10] = 1; m[11] = 1; m[12] = 1; m[13] = 1;
        // [1,1,1,1,1,1,1],
        m[14] = 1; m[15] = 1; m[16] = 1; m[17] = 1; m[18] = 1; m[19] = 1; m[20] = 1;
        // [1,1,0,1,1,0,1],
        m[21] = 1; m[22] = 1; m[23] = 0; m[24] = 1; m[25] = 1; m[26] = 0; m[27] = 1;
        // [1,1,1,1,1,1,1],
        m[28] = 1; m[29] = 1; m[30] = 1; m[31] = 1; m[32] = 1; m[33] = 1; m[34] = 1;
        // [1,1,1,1,1,1,1],
        m[35] = 1; m[36] = 1; m[37] = 1; m[38] = 1; m[39] = 1; m[40] = 1; m[41] = 1;
        // [1,1,1,1,1,1,1],
        m[42] = 1; m[43] = 1; m[44] = 1; m[45] = 1; m[46] = 1; m[47] = 1; m[48] = 1;

        NxNIslandMap _island = new NxNIslandMap(n, n, m);

        uint result = _island.mapIslands();
        assertEq(result, 48);
    }
}
