pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'IGameObject.sol';
import 'GameObject.sol';
import 'BaseStation.sol';

abstract contract MilitaryUnit is GameObject {
    BaseStation baseStation;    
    uint8 public damage;

    function attack(IGameObject target) public {
        tvm.accept();
        target.acceptAttack(damage, address(this));
    }

    function deathHandling(address attacker) public override {
        tvm.accept();
        baseStation.removeMilitaryUnit();
        sendAllFundsAndDestroy(attacker);
    }

    function deathDueBase() public {
        tvm.accept();
        require(baseStation == msg.sender, 104);
        sendAllFundsAndDestroy(msg.sender);
    }
}
