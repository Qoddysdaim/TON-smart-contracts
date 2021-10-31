pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'MilitaryUnit.sol';
import 'BaseStation.sol';

contract Warrior is MilitaryUnit {
    constructor(BaseStation station) public {
        tvm.accept();
        baseStation = station;
        station.addMilitaryUnit(this);    
        defense = 2;
        damage = 2;    
    }
}
