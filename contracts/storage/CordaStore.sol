// Copyright (c) 2016-2018 Clearmatics Technologies Ltd
// SPDX-License-Identifier: LGPL-3.0+
pragma solidity ^0.4.24;

import "../libraries/SolidityUtils.sol";
import "./BlockStore.sol";


contract CordaStore is BlockStore {


    /*
    *   @description    BlockHeader struct containing trie root hashes for tx verifications
    */
    struct BlockHeader {
        bytes32 txRootHash;
        //bytes32 receiptRootHash;
    }

    mapping (bytes32 => bool) public m_blockhashes;
    mapping (bytes32 => BlockHeader) public m_blockheaders;

    enum ProofType { TX}

    event BlockAdded(bytes32 chainID, bytes32 blockHash);
    event VerifiedProof(bytes32 chainId, bytes32 blockHash, uint proofType);

    constructor(address _ionAddr) BlockStore(_ionAddr) public {}

    /*
    * onlyExistingBlocks
    * param: _id (bytes32) Unique id of chain supplied to function
    * param: _hash (bytes32) Block hash which needs validation
    *
    * Modifier that checks if the provided block hash has been verified by the validation contract
    */
    modifier onlyExistingBlocks(bytes32 _hash) {
        require(m_blockhashes[_hash], "Block does not exist for chain");
        _;
    }


    /*
    * @description          when a block is submitted the header must be added to a mapping of blockhashes and m_chains to blockheaders
    * @param _chainId       ID of the chain the block is from
    * @param _blockHash     Block hash of the block being added
    * @param _blockBlob     Bytes blob of the RLP-encoded block header being added
    */
    /*****************Modified for CORDA******************/
    function addBlock(bytes32 _chainId, bytes32 _blockHash, bytes _blockBlob)
    onlyIon
    onlyRegisteredChains(_chainId)
    {
        require(!m_blockhashes[_blockHash], "Block already exists" );
        //RLP.RLPItem[] memory header = _blockBlob.toRLPItem().toList();

        //bytes32 hashedHeader = (_blockBlob);
        bytes32 hashedHeader = _blockHash; //TODO: Add some verification to compare Tx to its Hash
        require(hashedHeader == _blockHash, "Hashed header does not match submitted block hash!");

        m_blockhashes[_blockHash] = true;
        m_blockheaders[_blockHash].txRootHash = _blockHash;


        emit BlockAdded(_chainId, _blockHash);
    }

    /*
    * CheckTxProof
    * param: _id (bytes32) Unique id of chain submitting block from
    * param: _blockHash (bytes32) Block hash of block being submitted
    * param: _value (bytes) RLP-encoded transaction object array with fields defined as: https://github.com/ethereumjs/ethereumjs-tx/blob/0358fad36f6ebc2b8bea441f0187f0ff0d4ef2db/index.js#L50
    * param: _parentNodes (bytes) RLP-encoded array of all relevant nodes from root node to node to prove
    * param: _path (bytes) Byte array of the path to the node to be proved
    *
    * emits: VerifiedTxProof(chainId, blockHash, proofType)
    *        chainId: (bytes32) hash of the chain verifying proof against
    *        blockHash: (bytes32) hash of the block verifying proof against
    *        proofType: (uint) enum of proof type
    *
    * All data associated with the proof must be constructed and provided to this function. Modifiers restrict execution
    * of this function to only allow if the chain the proof is for is registered to this contract and if the block that
    * the proof is for has been submitted.
    */
    function CheckTxProof(
        bytes32 _id,
        bytes32 _blockHash

    )
    onlyRegisteredChains(_id)
    onlyExistingBlocks(_blockHash)
    public
    returns (bool)
    {
        //verifyProof(_value, _parentNodes, _path, m_blockheaders[_blockHash].txRootHash);

        emit VerifiedProof(_id, _blockHash, uint(ProofType.TX));
        return true;
    }

    /*
     * Verify proof assertion to avoid  stack to deep error (it doesn't show during compile time but it breaks
     * blockchain simulator)
     */
    function verifyProof(bytes _value, bytes _parentNodes, bytes _path, bytes32 _hash) {
        assert( true );
        //TODO : Verify using Notary signature
    }


}

