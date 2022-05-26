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
        uint visitedCount;
        uint maxSize;
    }

    struct GetAreaResult {
        bool deadEnd;
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
    uint public maxIslandSize;
    uint public expectedMaxIslandSize = 2;
    
    // Helper to track the current call depth
    uint callDepth;
    
    // Helpers 
    uint rowLength;
    uint colLength;

    constructor() {
        rowLength = matrix.length;
        colLength = matrix[0].length;
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
                console.log("  visitedCount: ", node.visitedCount);
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

        uint8 value = matrix[x][y];
        bool deadEnd = false;

        GetAreaResult memory result = GetAreaResult(
            false, maxSize
        );

        console.log("Value at", x, y);
        console.log("  is", value);
        console.log("  current maxSize", maxSize);
        console.log("  callDepth", callDepth);
        
        if (value == 1) {

            // If this is the value of 1, dive!
            maxSize++;

            console.log("  maxSize now", maxSize);
            console.log("  diving!");

            for(uint _x = x; _x < rowLength && !deadEnd; _x++) {
                deadEnd = false;
                
                for(uint _y = y+1; _y < colLength && !deadEnd; _y++ ) {
                    console.log("  Calling getArea", _x, _y);
                    callDepth++;
                    result = getArea(_x, _y, maxSize);

                    deadEnd = result.deadEnd;
                    maxSize = result.maxSize;
                    
                    console.log("  DeadEnd?", _x, _y, deadEnd);
                    callDepth--;
                }
            }
        } else {
            deadEnd = true;
        }

        graph[x][y].visited = true;
        graph[x][y].maxSize = maxSize;
        graph[x][y].visitedCount++;

        if (maxSize > maxIslandSize) {
            maxIslandSize = graph[x][y].maxSize;
        }

        console.log("");

        GetAreaResult memory finalResult = GetAreaResult(
            deadEnd,
            maxSize
        );
        
        return finalResult;
    }
}
