### This solves the NxN Binary Matrix question from leet code in Solidity:
https://leetcode.com/problems/making-a-large-island/

You can easily test with forge:

`$ forge test --match-contract NxNIslandMap --match-test test7x7Array -vv`

This will input a 7 x 7 array with two zeros in it and compute the max size of 48

There are several other tests provide, but feel free to Bring Your Own Matrix

The matrix arrays are semi-dynamic.. Solidty does not allow for an arbitrary n x n matrix to be passed in as a parm, so I had to get creative and pass in a flat array then then gets mapped to an n x n matrix. Look at the test for the 7 x 7 array to understand how to set this up.