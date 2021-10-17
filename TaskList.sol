pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract TaskList {
    
    struct Task {
        string name;
        uint32 timestamp;
        bool completed;
    }

    mapping (int8 => Task) taskList;
    int8 currentKey = 0;

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

    // Add task to the list 
    // The key is set automatically, like a counter in relational databases
    function addTask(string name) public checkOwnerAndAccept {
        taskList[currentKey] = Task(name, now, false);
        currentKey++;
    }

    // Get number of all tasks (uncompleted and completed)
    function numOfOpenTasks() 
        public 
        view 
        checkOwnerAndAccept 
        returns(uint8) 
    {
        uint8 count = 0;
        for (int8 key = 0; key < currentKey; key++) {
            if (taskList.exists(key) && !taskList[key].completed) {
                count++;
            }
        }
        return count;
    }

    // Get a list of tasks with their descriptions
    function viewList() 
        public 
        view 
        checkOwnerAndAccept 
        returns(mapping(int8 => Task)) 
    {
        return taskList;
    }

    // Get description of the task by key
    function getDescription(int8 key) 
        public 
        view 
        checkOwnerAndAccept 
        returns(Task) 
    {
        require(taskList.exists(key), 103, "Key does not exist.");
        return taskList[key];
    }

    // Delete task by key
    function deleteTask(int8 key) public checkOwnerAndAccept {
        require(taskList.exists(key), 103, "Key does not exist.");
        delete taskList[key];
    }

    // Mark task as completed by key
    function completeTask(int8 key) public checkOwnerAndAccept {
        require(taskList.exists(key), 103, "Key does not exist.");
        taskList[key].completed = true;
    }
}
