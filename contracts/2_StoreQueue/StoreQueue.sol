pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract StoreQueue {
    
    string[] public queue;

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    modifier checkOwnerAndAccept {
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
		_;
	}

    function joinQueue(string name) public checkOwnerAndAccept{
        queue.push(name);
    }
    
    function callNext() public checkOwnerAndAccept returns(string){
        require(!queue.empty(), 103, 'Queue is empty.');
        string nextName = queue[0];
        for (uint i = 1; i < queue.length; i++) {
            queue[i - 1] = queue[i];
        }
        queue.pop();
        return nextName;
    }
}
