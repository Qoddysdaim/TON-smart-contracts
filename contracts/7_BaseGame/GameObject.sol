pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "IGameObject.sol";

abstract contract GameObject is IGameObject {
    int32 public health = 5;
    uint32 public defense = 1;

    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 100);
		tvm.accept();
		_;
	}

    // get defence of game object, if sender is owner
    function getDefence(uint32 value) public checkOwnerAndAccept {
        defense = value;
    }

    // accept attack from another contract
    function acceptAttack(uint16 damage, address attacker) external override {
		tvm.accept();
        if (damage > defense) {
            health -= damage;
        }
        if (checkDeath()) {
            deathHandling(attacker);
        }
    }

    // check health of game object
    function checkDeath() internal returns(bool) {
        tvm.accept();
        return health <= 0;
    }

    function deathHandling(address attacker) virtual public {
        tvm.accept();
        sendAllFundsAndDestroy(attacker);
    }
    
    function sendAllFundsAndDestroy(address dest) internal {
        tvm.accept();
        selfdestruct(dest);
    }

}
