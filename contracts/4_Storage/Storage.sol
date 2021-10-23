pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "IStorage.sol";

contract Storage is IStorage {

    uint public storageValue;

    function storeUInt(uint value) public override {
        storageValue = value;
    }
}