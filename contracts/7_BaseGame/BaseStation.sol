pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'GameObject.sol';

contract BaseStation is GameObject {
    mapping (address => GameObject) army;

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    function addMilitaryUnit(GameObject unit) public {
        army[address(unit)] = unit;
    }
    function removeMilitaryUnit() public {
        tvm.accept();
        army.exists(msg.sender);
        delete army[msg.sender];
    }
    function deathHandling(address attacker) public override {
        for ((, GameObject unit) : army) {
            unit.deathHandling(attacker);
        }
        sendAllFundsAndDestroy(msg.sender);
    }
}
