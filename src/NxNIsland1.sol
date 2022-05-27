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
        [3,4,5],
        [6,7,8]
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

    // function CalculateIsland() public returns (uint) {
        
    //     for(uint x = 0; x < rowLength; x++) {
    //         for(uint y = 0; y < colLength; y++ ) {
    //             getArea(x, y, 0);
    //             console.log("");
    //         }
    //     }
        
    //     for ( uint x; x < rowLength; x++) {
    //         for (uint y; y < colLength; y++) {
    //             Node memory node = graph[x][y];
    //             console.log("Graph", x, y);
    //             console.log("  visited: ", node.visited);
    //             console.log("  maxSize: ", node.maxSize);
    //         }
            
    //     }

    //     return maxIslandSize;
    // }

    // function getArea(
    //     uint x,
    //     uint y,
    //     uint maxSize
    // ) internal returns (GetAreaResult memory) {
        
    //     // If we've already visited this node, return the result
    //     if (graph[x][y].visited == true) {
    //         return GetAreaResult(
    //             true,
    //             graph[x][y].maxSize
    //         );
    //     }
    //     // Otherwise, increment our node counter
    //     nodesVisited++;

    //     GetAreaResult memory result = GetAreaResult(
    //         false, // deadEnd bool
    //         maxSize
    //     );

    //     // current value
    //     uint8 value = matrix[x][y];

    //     // console.log("Value at", x, y);
    //     // console.log("  is", value);

    //     // Check for a "dead end" via 0
    //     if (value == 0) {
    //         result.deadEnd = true;

    //         console.log(value, result.maxSize);

    //         // Make sure to update this node
    //         graph[x][y].maxSize = result.maxSize;
    //         graph[x][y].visited = true;
            
    //         return result;
    //     }
    //     // else keep buidling up the size!
    //     result.maxSize++;

    //     console.log(value, result.maxSize);

    //     // console.log("  maxSize =>", maxSize, result.maxSize);
    //     // console.log("  callDepth", callDepth);

    //     // First let's look to the right, so increment x by 1
    //     // Keep going right until we hit deadEnd (boundry or a 0)
    //     // once we hit a deadEnd, increase y by one, and then start looping through X again

    //     uint localMaxSize;

    //     for(uint _y = y+1; _y < colLength && !result.deadEnd; _y++ ) {
    //         ++callDepth;
                
    //         result = getArea(x, _y, result.maxSize);

    //         if (result.maxSize > localMaxSize) {
    //             localMaxSize = result.maxSize;
    //         }
            
    //         --callDepth;
    //     }

    //     // Reset status and now search the columns
    //     result.deadEnd = false;

    //     for(uint _x = x+1; _x < rowLength && !result.deadEnd; ++_x) {
    //         ++callDepth;
            
    //         result = getArea(_x, y, result.maxSize);
            
    //         if (result.maxSize > localMaxSize) {
    //             localMaxSize = result.maxSize;
    //         }
            
    //         --callDepth;
    //     }

    //     // Once we're done with this node, map back the final results to our graph
    //     graph[x][y].maxSize = localMaxSize;
    //     graph[x][y].visited = true;

    //     if (localMaxSize > maxIslandSize) {
    //         maxIslandSize = localMaxSize;
    //     }

    //     console.log(value, localMaxSize);

    //     // console.log("");
        
    //     return result;
    // }

    // mapping (uint => mapping(uint => bool) ) public visited;
    // mapping (uint => mapping(uint => uint) ) public size;

    // function CalculateIsland2() public returns (uint) {
        
    //     for(uint x = 0; x < rowLength; x++) {
    //         for(uint y = 0; y < colLength; y++ ) {
    //             getArea2(x, y, 0);
    //             console.log("");
    //         }
    //     }
        
    //     for ( uint x; x < rowLength; x++) {
    //         for (uint y; y < colLength; y++) {
    //             console.log("Node", x, y);
    //             console.log("  Visited: ", visited[x][y]);
    //             console.log("  MaxSize: ", size[x][y]);
    //         }
            
    //     }

    //     console.log("MaxIsland: ", maxIslandSize);

    //     return maxIslandSize;
    // }

    //  function getArea2(
    //     uint x,
    //     uint y,
    //     uint inputSize
    // ) internal returns (uint) {

    //     if (visited[x][y]) {
    //         return inputSize + size[x][y];
    //     }

    //     visited[x][y] = true;

    //     uint value = matrix[x][y];

    //     console.log(value);

    //     // If this is a 0-node, then its a dead end for now
    //     if (value == 0) {
    //         size[x][y] = inputSize;
    //         return inputSize;
    //     }

    //     // Since this is non-zero, increase size by 1
    //     uint _size = inputSize + 1;

    //     uint _x = x;
    //     uint _y = y;

    //     console.log("(x,y) =>", x, y, _size);

    //     // else, increase out size and check the next node
    //     if (_x < maxRowLength ) {
    //         _size = getArea2(++_x, y, _size);
    //         if (_y < maxColLength ) {
    //             _size = getArea2(x, ++_y, _size);
    //         }
    //     }

    //     size[x][y] = _size;

    //     console.log("  (x,y) size => ", x, y, _size);

    //     return _size;
    // }

    // keep track of unique nodeIds
    uint nodeId;
    mapping (uint => mapping(uint => uint) ) public nodeIds;

    // Create a mapping of islands
    uint islandId;
    // Unique id => maps to a list of nodeIds
    mapping (uint => uint[]) islands;
    
    // for each node, track which island they belong to
    mapping (uint => uint) public nodeIslandMap;
    
    function mapIslands() public {

        // uint maxArea;

        nodeIds[0][1] = nodeId++;
        console.log(getIslandArea(0, 1, 0, ++islandId));

        // load up our nodeIds
        // for (uint x = 0; x < rowLength; x++) {
        //     for (uint y = 0; y < rowLength; y++) {
        //         // Assign a unique nodeId
        //         nodeIds[x][y] = nodeId++;

        //         // create a memory area to store the visited nodes
        //         // uint[] memory _visited = new uint[](rowLength * colLength);

        //         console.log(getIslandArea(x, y, 0, ++islandId));
        //     }
        // }

        // Ensure uniqueness
        // Loop through our matrix and determine the unique islands
        // console.log(nodeIds[0][0]);
        // console.log(nodeIds[0][1]);
        // console.log(nodeIds[0][2]);
    }

    function getIslandArea(
        uint x,
        uint y,
        uint area,
        uint _islandId
    ) public returns (uint) {

        // Track the local area
        uint _area = 0;
        
        // First, ensure this node has a uniqueId
        if (nodeIds[x][y] == 0) {
            nodeIds[x][y] = ++nodeId;
        }

        console.log("(x,y)", x, y);
        console.log("  nodeIds[x][y]", nodeIds[x][y]);
        console.log("  area =>", area);
        console.log("  _islandId => ", _islandId);
        console.log("  matrix[x][y] =>", matrix[x][y]);
        console.log("  nodeIslandMap[nodeIds[x][y]] =>", nodeIslandMap[nodeIds[x][y]]);

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
        
        // check up, translate by [0, -1]
        while (_y > 0) {
            console.log("  going left", _x, _y-1);
            _area += getIslandArea(x, --_y, area, _islandId);
        }
        // check down, translate by [0, 1]
        _y = y;
        while (_y < maxColLength) {
            console.log("  going right", _x, _y+1);
            _area += getIslandArea(x, ++_y, area, _islandId);
        }

        // check left, translate by [-1, 0]
        if (_x > 0) {
            console.log("  going up", _x-1, _y);
            _area += getIslandArea(--_x, y, area, _islandId);
        }

        // check right, translate by [1, 0]
        _x = x;
        while (_x < maxRowLength) {
            console.log("  going down", _x+1, _y);
            _area += getIslandArea(++_x, y, area, _islandId);
        }

        console.log("");

        return _area;
    }
}
