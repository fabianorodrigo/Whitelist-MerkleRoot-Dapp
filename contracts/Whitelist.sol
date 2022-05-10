// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

/**
 * @notice we are not storing the address of each user in the contract, instead, we are only storing the root of 
 * the merkle tree which gets initialized in the constructor.
 * 
 * @dev https://www.learnweb3.io/tracks/senior/merkle-trees
 */
contract Whitelist {

    bytes32 public merkleRoot;

    constructor(bytes32 _merkleRoot) {
        merkleRoot = _merkleRoot;
    }

    /**
     *  takes in a proof and maxAllowanceToMint. maxAllowanceToMint is a variable that keeps track of 
     * the number of NFT's a given address can mint.
     */
    function checkInWhitelist(bytes32[] calldata proof, uint64 maxAllowanceToMint) view public returns (bool) {
        bytes32 leaf = keccak256(abi.encode(msg.sender, maxAllowanceToMint));
        bool verified = MerkleProof.verify(proof, merkleRoot, leaf);
        return verified;
    }
    
}