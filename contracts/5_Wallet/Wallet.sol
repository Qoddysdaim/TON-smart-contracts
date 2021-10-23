pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

/// @title Simple wallet
/// @author Khanbekov

contract Wallet {
    /*
     Exception codes:
      100 - message sender is not a wallet owner.
      101 - invalid transfer value.
    */


    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }


    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 100);
		tvm.accept();
		_;
	}

    // Send a transaction, deducting a fee from the transaction amount
    function sendTransactionMinusFee(
        address dest, 
        uint128 value, 
        bool bounce
    ) public pure checkOwnerAndAccept {
        dest.transfer(value, bounce, 0);
    }

    // Send a transaction paying the fee separately from your account
    function sendTransactionPlusFee(
        address dest, 
        uint128 value, 
        bool bounce
    ) public pure checkOwnerAndAccept {
        dest.transfer(value, bounce, 1);
    }

    // Send all the money and destroy the wallet
    function sendAllFundsAndDestroy(
        address dest, 
        uint128 value, 
        bool bounce
    ) public pure checkOwnerAndAccept {
        dest.transfer(value, bounce, 160);
    }
}