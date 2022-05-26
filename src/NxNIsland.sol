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
        uint maxSize;
    }

    // Mappings like this need to be in storage, so let's define on the contract level
    mapping (uint => mapping(uint => Node) ) public graph;

    // Define the matix we'll be testing
    uint8[][] public matrix = [
        [0,1,1],
        [0,0,0],
        [0,0,0]
    ];
    uint rowLength;
    uint colLength;

    uint public maxIslandSize;

    constructor() {
        // Use -1 here to so we don't need to use <= later
        // using < vs. <= in solidty is a small gas savings
        // rowLength = matrix.length - 1;
        // colLength = matrix[0].length -1;

        rowLength = matrix.length;
        colLength = matrix[0].length;
    }

    function CalculateIsland() public returns (uint) {
        // getArea(0, 0, 0);
        // return maxIslandSize;
        
        for(uint x = 0; x < rowLength; x++) {
            for(uint y = 0; y < colLength; y++ ) {
                getArea(x,y,0);
            }
        }

        return maxIslandSize;
    }

    function getArea(
        uint x,
        uint y,
        uint maxSize
    ) internal returns (bool) {

        uint8 value = matrix[x][y];
        uint _maxSize = maxSize;
        bool deadEnd = true;

        console.log("Value at", x, y);
        console.log("is", value);
        console.log("maxSize", maxSize);
        console.log("");
        
        if (value == 1) {

            _maxSize++;
            
            for(uint _x = x; _x < rowLength && !deadEnd; _x++) {
                deadEnd = false;
                
                for(uint _y = 0; _y < colLength && !deadEnd; _y++ ) {
                    deadEnd = getArea(_x, _y, maxSize);
                    console.log("DeadEnd?", x, y, deadEnd);
                }
            }
        } else {
            deadEnd = true;
        }

        Node memory node = graph[x][y];
        node.visited = true;
        node.maxSize = _maxSize;

        if (node.maxSize > maxIslandSize) {
            maxIslandSize = node.maxSize;
        }
        
        return true;
    }
}
