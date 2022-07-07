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

contract NxNIslandMap {
    /// @dev Mapping of the N x N matrix -- So matrix[0][1] would be the 0th row and the first column
    mapping (uint => uint8[]) matrix;
    
    /// @dev Track the total length of the N x N matrix
    uint256 public matrixLength;

    /// @dev The number of rows, i.e 1, 2, 4, etc..
    uint rowCount;
    /// @dev The number of columns, i.e 1, 2, 4, etc..
    uint columnCount;
    
    /// @dev Save some gas by not having to use <= with 0-based indicies
    uint maxRowCount;
    /// @dev Save some gas by not having to use <= with 0-based indicies
    uint maxColumnCount;

    /// @dev Tracks the number of unique islands
    uint islandId;

    /// @dev A counter to keep track of unique nodes
    uint nodeId;

    /// @dev Mapping of x => y => nodeId to give each x,y coord a unique Id
    mapping (uint => mapping(uint => uint) ) public nodeIds;

    /// @dev Total number of nodes touch in the journey
    uint nodesVisited;      
    
    /// @dev Total number of nodes we performed traversal on i.e. if we run into a 0 node and exit, we don't count this as traversed
    uint nodesTraversed;

    /// @dev Maps Islandid to a list of nodeIds in that island
    mapping (uint => uint[]) islands;
    
    /// @dev Tracks the size of each island
    mapping (uint => uint) islandSize;

    /// @dev Track the "flipped" state of each island.. i.e. if we've flipped a 0 to 1
    mapping (uint => bool) islandZeroFlipped;
    
    /// @dev Reverse mapping for each node, track which island they belong to
    mapping (uint => uint) public nodeIslandMap;

    /// @dev Max island size discovered
    uint maxSize;
    /// @dev Id of the island with the max size
    uint largestIslandId;

    // --------------------------------------------------------
    // ~~ Constructor Logic ~~
    // --------------------------------------------------------

    /// @param _rowCount The number of rows in the matrix
    /// @param _columnCount The number of cols in the matrix
    /// @param _flatMatrix An array of all the elements that will be converted into a row x col matrix
    constructor(
        uint8 _rowCount,
        uint8 _columnCount,
        uint8[] memory _flatMatrix
    )
    {
        rowCount = _rowCount;
        columnCount = _columnCount;

        maxRowCount = rowCount - 1;
        maxColumnCount = columnCount - 1;

        if (_flatMatrix.length > 0) {
            for (uint i = 0; i < rowCount; i++) {
                for (uint j = 0; j < columnCount; j++) {
                    matrix[i].push(_flatMatrix[(i * columnCount) + j]);
                    matrixLength++;
                }
            }
        }
    }

    // --------------------------------------------------------
    // ~ Island Logic
    // --------------------------------------------------------
    /// @notice Call this function to map all islands in this matrix
    function mapIslands() public returns (uint) {

        // Loop through each row and then each col
        for (uint y = 0; y < rowCount; y++) {
            for (uint x = 0; x < columnCount; x++) {
                
                if (matrix[x][y] == 0) {
                    uint result = getIslandArea(x, y, ++islandId);
                    islandSize[islandId] = result;
                    // console.log("========");
                    // console.log("");

                    // Track the max size as we traverse
                    if (result > maxSize) {
                        maxSize = result;
                        largestIslandId = islandId;
                    }
                }                
            }
        }

        /// @dev Edge case! If the matrix does not contain any 0s then we need to return the full grid as the maxsize (i.e. its fully hydrated)
        if (maxSize == 0) {
            maxSize = rowCount * columnCount;
        }

        console.log("");
        console.log("// Final results:");
        console.log("   n =>", rowCount);
        console.log("   n^2 =>", rowCount * rowCount);
        console.log("   n^3 =>", rowCount * rowCount * rowCount);
        console.log("   n^4 =>", rowCount * rowCount * rowCount * rowCount);
        console.log("   nodesVisited =>", nodesVisited);
        console.log("   nodesTraversed =>", nodesTraversed);
        console.log("   max island size =>", maxSize);

        return maxSize;
    }

    /// @notice Internal helper function to map the area of a unique island
    /// @param x The starting x-coord
    /// @param y The starting y-coord
    /// @param _islandId The unique id for this island
    function getIslandArea(
        uint x,
        uint y,
        uint _islandId
    ) internal returns (uint) {

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
        while (_y < maxColumnCount) {
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
        while (_x < maxRowCount) {
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

    // --------------------------------------------------------
    // ~ Matrix helpers
    // --------------------------------------------------------

    function pushElement (uint row, uint8 el) external {
        matrix[row].push(el);
        matrixLength++;
    }
    function pushRow(uint rowIndex, uint8[] memory row) external {
        matrix[rowIndex] = row;
        matrixLength += row.length;
    }

    function getMatrixValue(uint x, uint y) public view returns (uint8) {
        return matrix[x][y];
    }
}
