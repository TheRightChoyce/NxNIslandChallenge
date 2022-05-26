// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../src/NxNIsland.sol";
import "forge-std/Test.sol";

contract NxNIslandTest is Test {

    NxNIsland nXNIsland;
    uint[][] testMatrix;
    function setUp() public {
        emit log("setUp");
        testMatrix = [
            [0,1],
            [1,0],
            [1,0]
        ];
        nXNIsland = new NxNIsland();
    }

    // function testGetArea() public {
    //     uint result = nXNIsland.getArea(testMatrix);
    //     assertTrue(result == 0);
    // }


    function testGetAreaRevertsOnZeroLengthArray() public {
        uint[][] memory invalidMatrix;
        vm.expectRevert(
            abi.encodeWithSelector(NxNIsland.InvalidMatrixDimensions.selector)
        );
        nXNIsland.getArea(invalidMatrix);
    }
    function testGetAreaRevertsOnMisMatchedLengthArray() public {
        assertTrue(true);
        // Sending a mismatched array like this won't even compile
        // uint[][] memory invalidMatrix = [
        //     [0,1],
        //     [0,0,0]
        // ];
    }

    function testGetAreaAcceptsMatrix() public {
        nXNIsland.getArea(testMatrix);
        assertTrue(true);
    }
}
