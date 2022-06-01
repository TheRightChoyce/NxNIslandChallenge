// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "forge-std/console.sol";

contract NxNIslandMap {
    // Mapping of the N x N matrix
    // So matrix[0][1] would be the 0th row and the first column
    mapping (uint => uint8[]) matrix;
    
    // Track the total length of the N x N matrix
    uint256 public matrixLength;

    // Helpers 
    uint rowCount;
    uint columnCount;

    // constructor(
    //     uint8[] memory _flatMatrix,
    //     uint numColumns
    // )
    // {
    //     uint rowIndex;
    //     uint rows = _flatMatrix.length / numColumns;

    //     for (uint i = 0; i < rows; i++) {
    //         uint8[] memory row = new uint8[](numColumns);

    //         // for (uint j = 0; j < _matrix[i].length; j++) {
    //         //     row[j] = uint8( _matrix[i][j] );
    //         // }

    //         matrix[rowIndex++] = row;
    //     }
    // }

     constructor(
        uint8 _rowCount,
        uint8 _columnCount,
        uint8[] memory _flatMatrix
    )
    {
        rowCount = _rowCount;
        columnCount = _columnCount;

        if (_flatMatrix.length > 0) {
            for (uint i = 0; i < rowCount; i++) {
                for (uint j = 0; j < columnCount; j++) {
                    matrix[i].push(_flatMatrix[(i * columnCount) + j]);
                    matrixLength++;
                }
            }
        }
    }

    function pushElement (uint row, uint8 el) external {
        matrix[row].push(el);
        matrixLength++;
    }
    function pushRow(uint rowIndex, uint8[] memory row) external {
        matrix[rowIndex] = row;
        matrixLength += row.length;
    }

    function getMatrixLength() public view returns (uint) {
        return matrixLength;
    }
    function getMatrixValue(uint x, uint y) public view returns (uint8) {
        return matrix[x][y];
    }
}
