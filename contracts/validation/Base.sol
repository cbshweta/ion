pragma solidity ^0.4.24;

import "../IonCompatible.sol";
import "../storage/BlockStore.sol";


contract Base is IonCompatible {
    constructor (address _ionAddr) IonCompatible(_ionAddr) public {}

    function register() public returns (bool) {
        ion.registerValidationModule();
        return true;
    }

    function RegisterChain(bytes32 _chainId, address _storeAddr) public {
        require( _chainId != ion.chainId(), "Cannot add this chain id to chain register" );
        ion.addChain(_storeAddr, _chainId);
    }

    function SubmitBlock(bytes32 _chainId, bytes _blockBlob, address _storageAddr) public {
        storeBlock(_chainId, _storageAddr, _blockBlob);
    }

    function storeBlock(
        bytes32 _chainId,
        address _storageAddr,
        bytes _blockBlob
    ) internal {
        // Add block to Ion
        ion.storeBlock(_storageAddr, _chainId, _blockBlob);
    }
}
