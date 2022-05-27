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
        [0,1,0],
        [3,0,5],
        [6,0,8]
    ];

    uint public maxIslandSize;
    uint public expectedMaxIslandSize = 8;
    
    // Helper to track the current call depth
    uint callDepth;
    uint nodesVisited;
    
    // Helpers 
    uint rowLength;
    uint colLength;
    uint maxRowLength;
    uint maxColLength;

    constructor() {
        rowLength = matrix.length;
        colLength = matrix[0].length;

        // Save some gas ?
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
    
    // for each node, track which island they belong to
    mapping (uint => uint) public nodeIslandMap;
    
    function mapIslands() public {

        // Loop through each
        for (uint x = 0; x < rowLength; x++) {
            for (uint y = 0; y < rowLength; y++) {
                uint result = getIslandArea(x, y, ++islandId);
                islandSize[islandId] = result;        
            }
        }

        uint maxSize;
        for (uint i = 1; i <= islandId; i++) {
            if (islandSize[i] > maxSize) {
                maxSize = islandSize[i];
            }
            console.log("IslandId => Length", i, islandSize[i]);
        }

        console.log("nodesVisited =>", nodesVisited);
        console.log("maxSize =>", maxSize);
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

        console.log("(x,y)", x, y);
        // console.log("  nodeIds[x][y]", nodeIds[x][y]);
        // console.log("  _islandId => ", _islandId);
        console.log("  matrix[x][y] =>", matrix[x][y]);
        // console.log("  nodeIslandMap[nodeIds[x][y]] =>", nodeIslandMap[nodeIds[x][y]]);

        // Check to see if this node is already in an island
        if (nodeIslandMap[nodeIds[x][y]] > 0) {
            console.log("    returning 0 -- this node is already part of an island!");
            return 0;
        }

        // If zero, return
        // TODO -- if this is the first time we encounter a zero,
        // flip it to 1 and continue
        if (matrix[x][y] == 0) {
            console.log("    returning 0!");
            return 0;
        }

        // See if we've already visited this island
        if (nodeIslandMap[nodeIds[x][y]] == _islandId) {
            console.log("    returning 0 -- already visited!");
            return 0;
        }

        // Since we passed all those checks, flag this as a new node visited
        nodesVisited++;

        // Include this node in the area
        _area++;
        
        // Map this node to this island, and then map this island to this node
        nodeIslandMap[nodeIds[x][y]] = _islandId;
        islands[_islandId].push(nodeId);
        

        // For each node, check all directions
        // In solidty v8+ we need to either check for out of bounds or flag 
        // this block as "unchecked"

        uint _y = y;
        uint _x = x;
        uint result;
        
        // check up, translate by [0, -1]
        while (_y > 0) {
            console.log("  going left", _x, _y-1);
            result = getIslandArea(x, --_y, _islandId);
            
            _area += result;
            
            // if zero result, don't keep traversing in this direction
            if (result == 0) {
                break;
            }
        }
        // check down, translate by [0, 1]
        _y = y;
        while (_y < maxColLength) {
            console.log("  going right", _x, _y+1);
            result = getIslandArea(x, ++_y, _islandId);
            _area += result;
            
            // if zero result, don't keep traversing in this direction
            if (result == 0) {
                break;
            }
        }

        // check left, translate by [-1, 0]
        while (_x > 0) {
            console.log("  going up", _x-1, _y);
            result = getIslandArea(--_x, y, _islandId);
            _area += result;
            
            // if zero result, don't keep traversing in this direction
            if (result == 0) {
                break;
            }
        }

        // check right, translate by [1, 0]
        _x = x;
        while (_x < maxRowLength) {
            console.log("  going down", _x+1, _y);
            result = getIslandArea(++_x, y, _islandId);
            _area += result;
            
            // if zero result, don't keep traversing in this direction
            if (result == 0) {
                break;
            }
        }

        console.log("");

        return _area;
    }
}
