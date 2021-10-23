pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "IStorage.sol";

contract StorageClient {
    function store(IStorage currentStorage, uint value) public pure {
        tvm.accept();
        currentStorage.storeUInt(value);
    }
}