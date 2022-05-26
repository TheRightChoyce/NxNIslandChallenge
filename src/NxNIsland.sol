// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "forge-std/console.sol";

// # You are given an n x n binary matrix grid. You are allowed to change at most one 0 to be 1.

// # Return the size of the largest island in grid after applying this operation.

// # An island is vertically and horizontally connected group of 1s.

// # Example 1:
// # Input: grid = [[1,0],[0,1]]
// # Output: 3
// # Explanation: Change one 0 to 1 and connect two 1s, then we get an island with area = 3.
// 1 0
// 0 1

// # Example 2:
// # Input: grid = [[1,1],[1,0]]
// # Output: 4
// # Explanation: Change the 0 to 1 and make the island bigger, only one island with area = 4.

// # Example 3:
// # Input: grid = [[1,1],[1,1]]
// # Output: 4
// # Explanation: Can't change any 0 to 1, only one island with area = 4.

// 
// 1 0 1 -- 1 
// 0 1 1 -- 1 
// 0 0 1 -- 1 
// 

contract NxNIsland {

    error InvalidMatrixDimensions();

    // Define a node structure that we can use to track each indice pair of a given graph.
    struct Node {
        bool visited;
        uint32 maxSize;
    }

    // Mappings like this need to be in storage, so let's define on the contract level
    mapping (uint => mapping(uint => Node) ) public graph;

    // Define the matix we'll be testing
    uint[][] public matrix;

    constructor(uint[][] memory _matrix) {
        console.log(matrix.length);
        if (_matrix.length == 0) {
            revert InvalidMatrixDimensions();
        }
        matrix = _matrix;
    }

    function getArea() public view returns (uint) {
        
        uint rows = matrix.length;
        uint cols = matrix[0].length;
        
        // revert("Not Implemented");
        return 0;
    }
}
