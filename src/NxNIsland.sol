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

    struct GetAreaResult {
        bool deadEnd;
        uint maxSize;
    }

    // Mappings like this need to be in storage, so let's define on the contract level
    mapping (uint => mapping(uint => Node) ) public graph;

    // Define the matix we'll be testing
    // uint8[][] public matrix = [
    //     [0,1,1],
    //     [0,1,0],
    //     [0,0,0]
    // ];
    uint8[][] public matrix = [
        [0,1,2],
        [3,4,5],
        [6,7,8]
    ];

    uint public maxIslandSize;
    uint public expectedMaxIslandSize = 3;
    
    // Helper to track the current call depth
    uint callDepth;
    uint nodesVisited;
    
    // Helpers 
    uint rowLength;
    uint colLength;

    constructor() {
        rowLength = matrix.length;
        colLength = matrix[0].length;
    }

    function getExpectedMaxIslandSize() public view returns (uint) {
        return expectedMaxIslandSize;
    }

    function getMatrix() public view returns (uint8[][] memory) {
        return matrix;
    }

    function CalculateIsland() public returns (uint) {
        
        for(uint x = 0; x < rowLength; x++) {
            for(uint y = 0; y < colLength; y++ ) {
                getArea(x, y, 0);
            }
        }
        
        for ( uint x; x < rowLength; x++) {
            for (uint y; y < colLength; y++) {
                Node memory node = graph[x][y];
                console.log("Graph", x, y);
                console.log("  visited: ", node.visited);
                console.log("  maxSize: ", node.maxSize);
            }
            
        }

        return maxIslandSize;
    }

    function getArea(
        uint x,
        uint y,
        uint maxSize
    ) internal returns (GetAreaResult memory) {
        
        // If we've already visited this node, return the result
        if (graph[x][y].visited == true) {
            return GetAreaResult(
                true,
                graph[x][y].maxSize
            );
        }
        // Otherwise, increment our node counter
        nodesVisited++;

        GetAreaResult memory result = GetAreaResult(
            false, // deadEnd bool
            maxSize
        );

        // current value
        uint8 value = matrix[x][y];

        console.log("Value at", x, y);
        console.log("  is", value);

        // Check for a "dead end" via 0
        if (value == 0) {
            result.deadEnd = true;

            // Make sure to update this node
            graph[x][y].maxSize = result.maxSize;
            graph[x][y].visited = true;
            
            return result;
        }
        // else keep buidling up the size!
        result.maxSize++;

        console.log("  maxSize =>", maxSize, result.maxSize);
        console.log("  callDepth", callDepth);

        graph[x][y].maxSize = result.maxSize;
        graph[x][y].visited = true;

        if (result.maxSize > maxIslandSize) {
            maxIslandSize = result.maxSize;
        }

        console.log("");
        
        return result;
    }
}
