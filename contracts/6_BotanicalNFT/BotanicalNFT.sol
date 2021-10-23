pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract BotanicalNFT {
    /*
     Exception codes:
      101 - token latin name is exist.
      102 - message sender is not a token owner.
      103 - message sender is not a owner token collection.
    */

    struct Token {
        string name;
        string latinName;
        string description;
        uint32 yearObtainName;
    }

    mapping (string => Token) tokenMap;
    string[] latinNamesArr;

    mapping (uint => uint) tokenToOwner;
    mapping (uint => uint) prices;

    modifier CheckOwnerAndAccept(uint tokenId) {
        tvm.accept();
        require(msg.pubkey() == tokenToOwner[tokenId], 102);
        _;
    }

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 103);
        tvm.accept();
    }

    function createToken(
        string name, 
        string latinName, 
        string description, 
        uint32 yearObtainName
    ) public {
        require(msg.pubkey() == tvm.pubkey(), 103);
        tvm.accept();
        // checking that the token does not exist
        require(!tokenMap.exists(latinName), 101);
        tokenMap[latinName] = Token(name, latinName, description, yearObtainName);
        latinNamesArr.push(latinName);
        uint keyAsLastNum = latinNamesArr.length - 1;
        tokenToOwner[keyAsLastNum] = msg.pubkey();

    }
    // returns the address of the token owner
    function getTokenOwner(uint tokenId) public view returns(uint) {
        return tokenToOwner[tokenId];
    }

   // returns parameteres of the token
    function getTokenInfo(uint tokenId) public view returns(
        string name, 
        string latinName, 
        string description, 
        uint32 yearObtainName
    ) {
        tvm.accept();
        Token currentToken = tokenMap[latinNamesArr[tokenId]];
        name = currentToken.name;
        latinName = currentToken.latinName;
        description = currentToken.description;
        yearObtainName = currentToken.yearObtainName;
    }

    // allows a change of ownership of a token
    function changeOwner(uint tokenId, uint pubKeyOfNewOwner) 
        public 
        CheckOwnerAndAccept(tokenId) 
    {
        tokenToOwner[tokenId] = pubKeyOfNewOwner;
    }

    // change a plant description of the token
    function changeDescriptipon(uint tokenId, string newDescription) 
        public 
        CheckOwnerAndAccept(tokenId) 
    {
        tokenMap[latinNamesArr[tokenId]].description = newDescription;
    }

    // set the price to sell the token
    function setTokenPrice(uint tokenId, uint price)
        public
        CheckOwnerAndAccept(tokenId) 
    {
        prices[tokenId] = price;
    }

}
