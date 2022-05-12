# Learnweb3.io - Merkle Trees / Merkle Root

Build up a Merkle Tree and just store the Merkle Root value in the contract - a measly bytes32 value. In this scenario, the contract is the Verifier, and users who wish to use their whitelist spot for minting NFTs, let's say, become the Provers proving that they are indeed part of the whitelist. Let's see how this would work.

The constructor receives the Merkle Root with the whitelist accounts and the respective NFTs minting allowed for each:

```solidity
constructor(bytes32 _merkleRoot) {
    merkleRoot = _merkleRoot;
}
```

checkInWhitelist function makes use of openzeppelin's MerkleProof to check the presence of account and quantity of NFTs allowed:

```solidity
function checkInWhitelist(bytes32[] calldata proof, uint64 maxAllowanceToMint) view public returns (bool) {
    bytes32 leaf = keccak256(abi.encode(msg.sender, maxAllowanceToMint));
    bool verified = MerkleProof.verify(proof, merkleRoot, leaf);
    return verified;
}
```

At the contract's deploy, creates the data and generates it's Merkle Root using `merkletreejs`:

```javascript
// Create an array of elements you wish to encode in the Merkle Tree
const list = [
  encodeLeaf(owner.address, 2),
  encodeLeaf(addr1.address, 2),
  encodeLeaf(addr2.address, 2),
  encodeLeaf(addr3.address, 2),
  encodeLeaf(addr4.address, 2),
  encodeLeaf(addr5.address, 2),
];

// Create the Merkle Tree using the hashing algorithm `keccak256`
// Make sure to sort the tree so that it can be produced deterministically regardless
// of the order of the input list
const merkleTree = new MerkleTree(list, keccak256, {
  hashLeaves: true,
  sortPairs: true,
});
// Compute the Merkle Root
const root = merkleTree.getHexRoot();
```

and passes the Merkle Root to the constructor:

```javascript
const whitelist = await ethers.getContractFactory("Whitelist");
const Whitelist = await whitelist.deploy(root);
await Whitelist.deployed();
```
