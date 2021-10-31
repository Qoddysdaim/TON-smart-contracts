pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

interface IGameObject {
    function acceptAttack(uint16, address) external;
}
