// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.11;

contract MerkelProof {
    //will take an array of hashes that needed to compute merkel root
    //merkel root
    //the hash of the element in the array that was used to construct merkel tree
    //this function will return true if merkel root from the proof, leaf, and index

    function verify(
        bytes32[] memory proof,
        bytes32 root,
        bytes32 leaf,
        uint256 index
    ) public pure returns (bool) {
        bytes32 hash = leaf;

        //recompute merkel root and then compare with provided merkel root
        //for loop that will update the hash with elements of proof.
        for (uint256 i = 0; i < proof.length; i++) {
            //left side of elements are even and right side odd
            //if index is even then we need to apend the proof element to current hash
            //then update our hash
            if (index % 2 == 0) {
                hash = keccak256(abi.encodePacked(hash, proof[i]));
            } else {
                //if index is odd which means our hash belongs to right branch
                //and we need to make hash of our hash before updating it
                hash = keccak256(abi.encodePacked(proof[i], hash));
            }
            //if our index is either 2k or 2k+1 then our parent index is equal to k
            //we divide our current index by 2 and round down to nearest integer
            index = index / 2;
        }
        return hash == root;
    }
    /*
    *lets say that there are 8 elements
    and we want to verify that the third element is contained in this merkel tree
    so the proof must be an array of hash of fourth element, the hash of the hashes of 
    the first and second element and the hash computed from the right side of merkel tree 
    the leaf would be hash of third element and index will be 2
    */
}
