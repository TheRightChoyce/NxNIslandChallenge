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

contract NxNIsland {

    // Define the matix we'll be testing
    uint8[][] public matrix = [
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

        [0,0,0,0,0,0,0], // expected 1
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0]
    ];

    uint public maxIslandSize;
    uint public expectedMaxIslandSize = 1;
    
    // Total number of nodes touch in the journey
    uint nodesVisited;      
    
    // Total number of nodes we performed traversal on i.e. if we run into 
    // a 0 node and exit, we don't count this as traversed
    uint nodesTraversed;    

    // Helpers 
    uint rowLength;
    uint colLength;
    uint maxRowLength;
    uint maxColLength;

    constructor() {
        rowLength = matrix.length;
        colLength = matrix[0].length;

        // Save some gas by not having to constantly do <= on 0-based numbers
        maxRowLength = matrix.length - 1;
        maxColLength = matrix[0].length - 1;
    }

    function getExpectedMaxIslandSize() public view returns (uint) {
        return expectedMaxIslandSize;
    }

    function getMatrix() public view returns (uint8[][] memory) {
        return matrix;
    }

    // keep track of unique nodeIds
    uint nodeId;
    mapping (uint => mapping(uint => uint) ) public nodeIds;

    // Create a mapping of islands
    uint islandId;
    
    // Unique id => maps to a list of nodeIds
    mapping (uint => uint[]) islands;
    
    // Track the size of each island
    mapping (uint => uint) islandSize;

    // Track the "flipped" state of each island.. i.e. if we've flipped a 0 to 1
    mapping (uint => bool) islandZeroFlipped;
    
    // for each node, track which island they belong to
    mapping (uint => uint) public nodeIslandMap;

    // Max Island Size
    uint maxSize;
    uint largestIslandId;
    
    function mapIslands() public returns (uint) {

        // If desired, create the nodeIds in advance for easy debugging
        // for (uint y = 0; y < rowLength; y++) {
        //     for (uint x = 0; x < rowLength; x++) {
        //         nodeIds[x][y] = ++nodeId;
        //     }
        // }

        // Loop through each row and then each col
        for (uint y = 0; y < rowLength; y++) {
            for (uint x = 0; x < rowLength; x++) {
                
                if (matrix[x][y] == 0) {
                    uint result = getIslandArea(x, y, ++islandId);
                    islandSize[islandId] = result;
                    console.log("========");
                    console.log("");

                    // Track the max size as we traverse
                    if (result > maxSize) {
                        maxSize = result;
                        largestIslandId = islandId;
                    }
                }                
            }
        }

        // Edge case! If the matrix does not contain any 0s then we need to return the full grid as the maxsize (i.e. its fully hydrated)
        if (maxSize == 0) {
            maxSize = rowLength * colLength;
        }

        console.log("");
        console.log("// Final results:");
        console.log("   n =>", rowLength);
        console.log("   n^2 =>", rowLength * rowLength);
        console.log("   n^3 =>", rowLength * rowLength * rowLength);
        console.log("   n^4 =>", rowLength * rowLength * rowLength * rowLength);
        console.log("   nodesVisited =>", nodesVisited);
        console.log("   nodesTraversed =>", nodesTraversed);
        console.log("   max island size =>", maxSize);

        return maxSize;
    }

    function getIslandArea(
        uint x,
        uint y,
        uint _islandId
    ) public returns (uint) {

        // Track the local area
        uint _area = 0;
        
        // First, ensure this node has a uniqueId
        if (nodeIds[x][y] == 0) {
            nodeIds[x][y] = ++nodeId;
        }

        // Track this node as being visited, even if we do nothing with it
        nodesVisited++;

        console.log("(x,y)", x, y);
        console.log("  NodeId =>", nodeIds[x][y]);
        console.log("  Value =>", matrix[x][y]);
        
        // if this is the first time we encounter a 0 flip to 1 and continue
        if (matrix[x][y] == 0) {

            if (islandZeroFlipped[_islandId] == false)
            {
                islandZeroFlipped[_islandId] = true;
                console.log("    encountered first 0 -- flipping!");
            }
            else {
                console.log("    returning 0!");
                return 0;
            }
        }

        // Exit if we've already visited this node on this island tour
        if (nodeIslandMap[nodeIds[x][y]] == _islandId) {
            console.log("    returning 0 -- already visited!");
            return 0;
        }

        // Since we passed all those checks, flag this as a new node visited
        nodesTraversed++;

        // Include this node in the area
        _area++;
        
        // Map this node to this island, and then map this island to this node
        nodeIslandMap[nodeIds[x][y]] = _islandId;
        islands[_islandId].push(nodeIds[x][y]);
        

        // For each node, check all directions
        // In solidty v8+ we need to either check for out of bounds in advance
        //  OR use the "unchecked" command to wrap everything

        uint _y = y;
        uint _x = x;
        uint result;
        
        // check "down", translate by [0, 1] -- ie increase y from 0 -> 1 -> 2
        while (_y < maxColLength) {
            console.log("  going down", x, _y+1);
            result = getIslandArea(x, ++_y, _islandId);
            _area += result;
            
            // if zero result, don't keep traversing in this direction
            if (result == 0) {
                break;
            }
        }
        // check "up", translate by [0, -1] -- ie decrease y from 2 -> 1 -> 0
        _y = y;
        while (_y > 0) {
            console.log("  going up", x, _y-1);
            result = getIslandArea(x, --_y, _islandId);
            
            _area += result;
            
            // if zero result, don't keep traversing in this direction
            if (result == 0) {
                break;
            }
        }
        
        // check "right", translate by [1, 0] - ie increase x from 0 -> 1 -> 2
        while (_x < maxRowLength) {
            console.log("  going right", _x+1, y);
            result = getIslandArea(++_x, y, _islandId);
            _area += result;
            
            // if zero result, don't keep traversing in this direction
            if (result == 0) {
                break;
            }
        }

        // check "left", translate by [-1, 0] - ie decrease x from 2 -> 1 -> 0
        _x = x;
        while (_x > 0) {
            console.log("  going left", _x-1, y);
            result = getIslandArea(--_x, y, _islandId);
            _area += result;
            
            // if zero result, don't keep traversing in this direction
            if (result == 0) {
                break;
            }
        }

        console.log("");
        console.log("  Exiting branch (x,y)", x, y);
        console.log("  Area =>", _area);

        return _area;
    }

    function logIsland(uint _islandId) public view {
        for( uint i = 0; i < islands[_islandId].length; i++) {
            console.log(islands[_islandId][i]);
        }
    }
    function logLongestIsland() public view {
         for( uint i = 0; i < islands[largestIslandId].length; i++) {
            console.log(islands[largestIslandId][i]);
         }
    }
}
