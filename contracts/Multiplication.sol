pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Multiplication {
    uint public number = 1;

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    function multiply(uint multiplier) public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
        // Check if number is in valid range
        require(multiplier >= 1 && multiplier <= 10, 103, 
            "the number is out of range (less than 1 or greater than 10).");

        number *= multiplier;
    }
}
