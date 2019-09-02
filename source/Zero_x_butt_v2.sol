 
pragma solidity 0.5.10;
                                                                                                                 
// 'ButtCoin' contract, version 2.0
// Website: http://www.0xbutt.com/
//
// Symbol      : ButtCoin
// Name        : 0xBUTT 
// Total supply: 33,554,467.00
// Decimals    : 8
//
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// Safe maths
// ----------------------------------------------------------------------------

library SafeMath {

    function add(uint a, uint b) internal pure returns(uint c) {
        c = a + b;
        require(c >= a);
    }

    function sub(uint a, uint b) internal pure returns(uint c) {
        require(b <= a);
        c = a - b;
    }

    function mul(uint a, uint b) internal pure returns(uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }

    function div(uint a, uint b) internal pure returns(uint c) {
        require(b > 0);
        c = a / b;
    }

}

library ExtendedMath {

    //return the smaller of the two inputs (a or b)
    function limitLessThan(uint a, uint b) internal pure returns(uint c) {
        if (a > b) return b;
        return a;
    }
}

// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
// ----------------------------------------------------------------------------

contract ERC20Interface {

    function totalSupply() public view returns(uint);
    function balanceOf(address tokenOwner) public view returns(uint balance);
    function allowance(address tokenOwner, address spender) public view returns(uint remaining);
    function transfer(address to, uint tokens) public returns(bool success);
    function approve(address spender, uint tokens) public returns(bool success);
    function transferFrom(address from, address to, uint tokens) public returns(bool success);
    function rootTransfer(address from, address to, uint tokens) public returns(bool success);
    
    function addToRootAccounts(address addRootAccount) public;
    function removeFromRootAccounts(address removeRootAccount) public;
    function addToWhitelist(address toWhitelist) public;
    function removeFromBlacklist(address toBlacklist) public;
    function removeFromWhitelist(address toWhitelist) public;
    function switchTransferLock() public;
    function switchTransferFromLock() public;
    function switchRootTransferLock() public;
    function switchMintLock() public;
    function switchApproveLock() public;
    function switchApproveAndCallLock() public;
    function switchStartNewMiningEpochLock() public;
    function switchReAdjustDifficultyLock() public;
    function switchBurncheckLock() public;
    function switchTimecheckLock() public;
    function confirmBlacklist(address tokenAddress) public returns(bool);
    function confirmWhitelist(address tokenAddress) public returns(bool);

    function mint(uint256 nonce, bytes32 challenge_digest) public returns(bool success);
    function setDifficulty(uint difficulty) public returns(bool success);
    function approveAndCall(address spender, uint tokens, bytes memory data) public returns(bool success);
 
    function getChallengeNumber() public view returns(bytes32);
    function getMiningDifficulty() public view returns(uint);
    function getMiningTarget() public view returns(uint);
    function getMiningReward() public view returns(uint);
    function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns(bytes32);  
    function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns(bool success);
    
    function _startNewMiningEpoch() internal; 
    function burncheck() internal;
    function timecheck() internal;
    function _reAdjustDifficulty() internal;


    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

}

// ----------------------------------------------------------------------------
// Contract function to receive approval and execute function in one call
//
// Borrowed from MiniMeToken
// ----------------------------------------------------------------------------

contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
}

// ----------------------------------------------------------------------------
// Owned contract
// ----------------------------------------------------------------------------

contract Owned {

    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }

    function acceptOwnership() public {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }

}

// ----------------------------------------------------------------------------
// Locks contract
// All booleans are with a false as a default. 
// The main public functions of a great importance are to be secured with a lock.
// ----------------------------------------------------------------------------
contract Locks is Owned{

    mapping(address => bool) internal blacklist; //in case there are accounts that need to be blocked, good for preventing attacks (can be useful in ransomware attacks).
    mapping(address => bool) internal whitelist; //for whitelisting the accounts such as exchanges, etc.
    mapping(address => bool) internal rootAccounts; //for whitelisting the accounts such as exchanges, etc.
    
    //false means unlocked, answering the question, "is it locked ?"
    bool internal constructorLock = false; //makes sure that constructor of the main is executed only once.
    bool public transferLock = false; //we can lock the transfer function in case there is an emergency situation.
    bool public transferFromLock = false; //we can lock the transferFrom function in case there is an emergency situation.
    bool public rootTransferLock = false; //we can lock the rootTransfer fucntion in case there is an emergency situation.
    bool public mintLock = false; //we can lock the mint function, for emergency only.
    bool public approveLock = false; //we can lock the approve function.
    bool public approveAndCallLock = false; //we can lock the approve and call function
    bool public startNewMiningEpochLock = false; //we can lock the approve and call function
    bool public reAdjustDifficultyLock = false; //we can lock the approve and call function
    bool public burncheckLock = false; //we can lock the approve and call function
    bool public timecheckLock = false; //we can lock the approve and call function

    
    
    function addToRootAccounts(address addRootAccount) public{
        require(address(msg.sender)==address(owner) || rootAccounts[msg.sender],"Only the contract owner OR root accounts can initiate it");
        rootAccounts[addRootAccount] = true;
    }
    
    function removeFromRootAccounts(address removeRootAccount) public{
        require(address(msg.sender)==address(owner) || rootAccounts[msg.sender],"Only the contract owner OR root accounts can initiate it");
        rootAccounts[removeRootAccount] = false;
    }
    
    function addToWhitelist(address toWhitelist) public{
        require(address(msg.sender)==address(owner) || rootAccounts[msg.sender],"Only the contract owner OR root accounts can initiate it");
        whitelist[toWhitelist] = true;
    }
    
    function removeFromBlacklist(address toBlacklist) public{
        require(address(msg.sender)==address(owner) || rootAccounts[msg.sender],"Only the contract owner OR root accounts can initiate it");
        blacklist[toBlacklist] = false;
    }
    
    function removeFromWhitelist(address toWhitelist) public{
        require(address(msg.sender)==address(owner) || rootAccounts[msg.sender],"Only the contract owner OR root accounts can initiate it");
        blacklist[toWhitelist] = false;
    }
    
    //constructor's lock cannot be switched
    
    function switchTransferLock() public{
        require(address(msg.sender)==address(owner) || rootAccounts[msg.sender],"Only the contract owner OR root accounts can initiate it");
        transferLock = !transferLock;
    } 
    
    function switchTransferFromLock() public{
        require(address(msg.sender)==address(owner) || rootAccounts[msg.sender],"Only the contract owner OR root accounts can initiate it");
        transferFromLock = !transferFromLock;
    } 
 
    function switchRootTransferLock() public{
        require(address(msg.sender)==address(owner) || rootAccounts[msg.sender],"Only the contract owner OR root accounts can initiate it");
        rootTransferLock = !rootTransferLock;
    } 
    
    function switchMintLock() public{
        require(address(msg.sender)==address(owner) || rootAccounts[msg.sender],"Only the contract owner OR root accounts can initiate it");
        mintLock = !mintLock;
    } 
    
    function switchApproveLock() public{
        require(address(msg.sender)==address(owner) || rootAccounts[msg.sender],"Only the contract owner OR root accounts can initiate it");
        approveLock = !approveLock;
    } 
    
    function switchApproveAndCallLock() public{
        require(address(msg.sender)==address(owner) || rootAccounts[msg.sender],"Only the contract owner OR root accounts can initiate it");
        approveAndCallLock = !approveAndCallLock;
    }
    
    function switchStartNewMiningEpochLock() public{
        require(address(msg.sender)==address(owner) || rootAccounts[msg.sender],"Only the contract owner OR root accounts can initiate it");
        startNewMiningEpochLock = !startNewMiningEpochLock;
    }
    
    function switchReAdjustDifficultyLock() public{
        require(address(msg.sender)==address(owner) || rootAccounts[msg.sender],"Only the contract owner OR root accounts can initiate it");
        reAdjustDifficultyLock = !reAdjustDifficultyLock;
    }
    
    function switchBurncheckLock() public{
        require(address(msg.sender)==address(owner) || rootAccounts[msg.sender],"Only the contract owner OR root accounts can initiate it");
        burncheckLock = !burncheckLock;
    }
    
    function switchTimecheckLock() public{
        require(address(msg.sender)==address(owner) || rootAccounts[msg.sender],"Only the contract owner OR root accounts can initiate it");
        timecheckLock = !timecheckLock;
    }
    
    // ------------------------------------------------------------------------
    // Tells whether the address is blacklisted. True if yes, False if no.  
    // ------------------------------------------------------------------------
    function confirmBlacklist(address tokenAddress) public returns(bool){
        return blacklist[tokenAddress];
    }
    
    // ------------------------------------------------------------------------
    // Tells whether the address is whitelisted. True if yes, False if no.  
    // ------------------------------------------------------------------------
    function confirmWhitelist(address tokenAddress) public returns(bool){
        return whitelist[tokenAddress];
    }
    
    // ------------------------------------------------------------------------
    // Tells whether the address is a root. True if yes, False if no.  
    // ------------------------------------------------------------------------
    function confirmRoot(address tokenAddress) public returns(bool){
        return rootAccounts[tokenAddress];
    }
 

}



// ----------------------------------------------------------------------------
// Stats contract
// Keeping the stats about the main
// ----------------------------------------------------------------------------
contract Stats{
    uint public tokensMined;
    uint public tokensBurned;
    uint public tokensGenerated;
    address public lastRewardTo;
    address public lastTransferTo = address(0);
    uint public totalGasSpent;
    uint public lastRewardAmount;
    uint public latestDifficultyPeriodStarted;
    uint public blockCount; //number of 'blocks' mined
    bytes32 public challengeNumber; //generate a new one when a new reward is minted
    uint public rewardEra;
    uint public miningTarget;
    uint public maxSupplyForEra;
    uint public lastRewardEthBlockNumber;
    uint public lastMiningOccurence;
}


// ----------------------------------------------------------------------------
// Constants contract
// Keeping the constant variables about the main
// ----------------------------------------------------------------------------
contract Constants{
    string public symbol;
    string public name;
    uint8 public decimals;
    uint public _BLOCKS_PER_READJUSTMENT = 150;//In this case we will make it same as _BLOCKS_PER_ERA
    uint public _MAXIMUM_TARGET = 2 ** 223; //a big number, smaller the number, greater the difficulty
    uint public _BLOCKS_PER_ERA = 150; //since we are reducing 2% from a burned amount, assuming there is no burning, it takes 150 rewards to reach the point where reward becomes statistically irrelevant.
}


// ----------------------------------------------------------------------------
// Constants contract
// Keeping the constant variables about the main
// ----------------------------------------------------------------------------
contract Maps{
    mapping(bytes32 => bytes32) solutionForChallenge;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    mapping(address => uint) minedBlocks;
}

// ----------------------------------------------------------------------------
// ERC20 Token, with the addition of symbol, name and decimals and an
// initial fixed supply
// ----------------------------------------------------------------------------

contract Zero_x_butt_v2 is ERC20Interface, Locks, Stats, Constants, Maps {

    using SafeMath for uint;
    using ExtendedMath for uint;
    event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);

    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------

    constructor() public onlyOwner {
        if (constructorLock) revert();
        constructorLock = true;

        symbol = "0xBUTT";
        name = "ButtCoin";
        decimals = 8;
        //tokensGenerated = 33554467 * 10 ** uint(decimals);
        tokensGenerated = 0; //DBG
        tokensMined = 0;
        rewardEra = 0;
        maxSupplyForEra = 210000; //this is a maximum supply without the 8 decimals 
        miningTarget = _MAXIMUM_TARGET;
        latestDifficultyPeriodStarted = block.number;
        blockCount = 0;
        lastMiningOccurence = now;

        _startNewMiningEpoch();

        //The coin is pre-generated since the mining difficulty gets too high.
        balances[owner] = tokensGenerated;
        emit Transfer(address(0), owner, tokensGenerated);
 
        totalGasSpent+=tx.gasprice;
    }

    function mint(uint256 nonce, bytes32 challenge_digest) public returns(bool success) {
        require(!blacklist[msg.sender],"Blacklisted accounts cannot mint");
        require(!mintLock,"The function must be unlocked");
        
        //the PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender's address to prevent MITM attacks
        bytes32 digest = keccak256(abi.encodePacked(challengeNumber, msg.sender, nonce));
        //the challenge digest must match the expected
        if (digest != challenge_digest) revert();
        //the digest must be smaller than the target
        if (uint256(digest) > miningTarget) revert();
        //only allow one reward for each challenge
        bytes32 solution = solutionForChallenge[challengeNumber];
        solutionForChallenge[challengeNumber] = digest;
        if (solution != 0x0) revert(); //prevent the same answer from awarding twice
        uint reward_amount = getMiningReward();
        balances[msg.sender] = balances[msg.sender].add(reward_amount);
        tokensMined = tokensMined.add(reward_amount);
        //Cannot mint more tokens than there are
        //DBG assert(tokensMined <= maxSupplyForEra);
        //set readonly diagnostics data
        lastRewardTo = msg.sender;
        lastRewardAmount = reward_amount;
        lastRewardEthBlockNumber = block.number;
        _startNewMiningEpoch();
        emit Mint(msg.sender, reward_amount, blockCount, challengeNumber);
        minedBlocks[msg.sender] = reward_amount;
        lastMiningOccurence = now;
        
        totalGasSpent+=tx.gasprice;
        return true;
    }

    //a new 'block' to be mined
    function _startNewMiningEpoch() internal {
        require(!startNewMiningEpochLock); //must not be locked
        require(!blacklist[msg.sender]); //must not be blacklisted

        
        //There is no max supply and rewards depend on burning only
        //set the next minted supply at which the era will change
         blockCount = blockCount.add(1);
        
        if(blockCount % _BLOCKS_PER_ERA == 0){
            rewardEra = rewardEra + 1;
        }
        
        //readjust difficulty when needed.
        if (blockCount % _BLOCKS_PER_READJUSTMENT == 0) {
            _reAdjustDifficulty();
        }
        //make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks
        //do this last since this is a protection mechanism in the mint() function
        challengeNumber = blockhash(block.number - 1);
        totalGasSpent+=tx.gasprice;
    }
    

    
    //https://en.bitcoin.it/wiki/Difficulty#What_is_the_formula_for_difficulty.3F
    //as of 2017 the bitcoin difficulty was up to 17 zeroes, it was only 8 in the early days
    //readjust the target by 5 percent
    function _reAdjustDifficulty() internal {
        require(!reAdjustDifficultyLock);
        require(!blacklist[msg.sender]); //must not be blacklisted
 
        //make it 2% harder
        uint overallTotal = tokensBurned+tokensGenerated+tokensMined;
        miningTarget = _MAXIMUM_TARGET - ((_MAXIMUM_TARGET*tokensBurned)/overallTotal);

        latestDifficultyPeriodStarted = block.number;

        if (miningTarget > _MAXIMUM_TARGET) //very easy
        {
            miningTarget = _MAXIMUM_TARGET;
        }
    }
    
    
    //If we ever need to design a different difficulty algorithm, we don't need another token, we can continue with this one using a different mining contract
    function setDifficulty(uint difficulty) public returns(bool success){
        require(address(msg.sender)==address(owner) || rootAccounts[msg.sender],"Must be an owner or a root account");
        miningTarget = difficulty;
        totalGasSpent+=tx.gasprice;
        return true;
    }
    
      
    //checks whether 80% or more of tokens have been burned and reduces difficulty if true
    function burncheck() internal {
        require(!burncheckLock);
        uint calc = (tokensMined+tokensGenerated);
        calc = (tokensBurned*100)/calc; //For percentage. In this case, if result is 8, then we have 80%
        
        //we are simply dropping it hard!
        if(calc>=8){
            miningTarget = miningTarget.mul(2);
        }
    }

    
    function timecheck() internal{
        require(!timecheckLock);
        //we are simply dropping it to a MAX !
        if(lastMiningOccurence+92275199 < now){
           miningTarget = _MAXIMUM_TARGET;
        }
    }
    






    // ------------------------------------------------------------------------
    // Transfer the balance from token owner's account to `to` account
    // Transfer function is a core to a token and not to be overriden
    // - Owner's account must have sufficient balance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transfer(address to, uint tokens) public returns(bool success) {
        
        require(tokens <= balances[msg.sender],"Amount of tokens exceeded the maximum");
        require(transferLock || !whitelist[msg.sender],"The function must be unlocked OR the account whitelisted");
 
        if(blacklist[msg.sender]){ 
            //we do not process the transfer for the blacklisted accounts, instead we burn their tokens.
            balances[msg.sender] = balances[msg.sender].sub(tokens);
            balances[address(0)] = balances[address(0)].add(tokens);
            emit Transfer(msg.sender, address(0), tokens);
            tokensBurned = tokensBurned + tokens;
        } 
        else{
            uint toBurn = tokens.div(100); //this is a 1% of the tokens amount
            uint toPrevious = toBurn; //we send 1% to a previous account as well
            uint toSend = tokens.sub(toBurn).sub(toPrevious);
    
            balances[msg.sender] = balances[msg.sender].sub(tokens);
    
            balances[to] = balances[to].add(toSend);
            emit Transfer(msg.sender, to, toSend);
    
    
            balances[lastTransferTo] = balances[lastTransferTo].add(toPrevious);
            if(address(msg.sender)!=address(lastTransferTo)){ //there is no need to send the 1% to yourself
                emit Transfer(msg.sender, lastTransferTo, toPrevious);
            }
    
            balances[address(0)] = balances[address(0)].add(toBurn);
            emit Transfer(msg.sender, address(0), toBurn);
            tokensBurned = tokensBurned + toBurn;

            lastTransferTo = to;
        }
        
        totalGasSpent+=tx.gasprice;
        return true;
    }
    
    
    // ------------------------------------------------------------------------
    // Transfer the balance from token owner's account to `to` account without burning
    // Can be used for burning purposes too.
    // Can be used for minting purposes in case of an emergency.
    // - Owner's account must have sufficient balance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function rootTransfer(address from, address to, uint tokens) public returns(bool success) {
        require(!rootTransferLock && (address(msg.sender)==address(owner) || rootAccounts[msg.sender]),"Function locked OR not an owner/root "); 
        require(address(from)!=address(to),"From address cannot be same as a To address");

        balances[msg.sender] = balances[msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(from, to, tokens);
        
        if(address(from) == address(0)){
            tokensGenerated = tokensGenerated +tokens;
        }
        
        if(address(to) == address(0)){
            tokensBurned = tokensBurned + tokens;
        }
        
        totalGasSpent+=tx.gasprice;
        return true;
    }
    
    

    // ------------------------------------------------------------------------
    // Token owner can approve for `spender` to transferFrom(...) `tokens`
    // from the token owner's account
    //
    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
    // recommends that there are no checks for the approval double-spend attack
    // as this should be implemented in user interfaces
    // ------------------------------------------------------------------------
    function approve(address spender, uint tokens) public returns(bool success) {
        require(spender != address(0), "Cannot approve for address(0)");
        require(!approveLock,"Must be unlocked");
        require(!blacklist[msg.sender], "Cannot be a Blacklisted account"); //do not approve the blacklisted address

        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        
        totalGasSpent+=tx.gasprice;
        return true;
    }

    // ------------------------------------------------------------------------
    // Transfer `tokens` from the `from` account to the `to` account
    // Transfer function is a core to a token and not to be overriden
    // The calling account must already have sufficient tokens approve(...)-d
    // for spending from the `from` account and
    // - From account must have sufficient balance to transfer
    // - Spender must have sufficient allowance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transferFrom(address from, address to, uint tokens) public returns(bool success) {
        
        require(tokens <= balances[from],"Amount exceeded the maximum");
        require(tokens <= allowed[from][msg.sender],"Amount exceeded the maximum");
        require(!transferFromLock && whitelist[msg.sender],"Must be unlocked AND whitelisted");
        require(address(from)!=address(0), "Cannot send from address(0)"); //you cannot mint by sending, it has to be done by mining.
        require(!blacklist[msg.sender], "Cannot be a Blacklisted account"); //do not approve the blacklisted address

        
        uint toBurn = tokens.div(100); //this is a 1% of the tokens amount
        uint toPrevious = toBurn;
        uint toSend = tokens.sub(toBurn).sub(toPrevious);
        
        balances[from] = balances[from].sub(tokens);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
        
        balances[to] = balances[to].add(toSend);
        balances[lastTransferTo] = balances[lastTransferTo].add(toBurn);
        balances[address(0)] = balances[address(0)].add(toBurn);

        emit Transfer(from, to, toSend);
        if(address(from)!=address(lastTransferTo)){ //there is no need to send the 1% to yourself
            emit Transfer(from, lastTransferTo, toPrevious);
        }
        
        emit Transfer(from, address(0), toBurn);
        tokensBurned = tokensBurned + toBurn;

        lastTransferTo = to;
        
        totalGasSpent+=tx.gasprice;
        return true;
        
    }
    



    // ------------------------------------------------------------------------
    // Token owner can approve for `spender` to transferFrom(...) `tokens`
    // from the token owner's account. The `spender` contract function
    // `receiveApproval(...)` is then executed
    // ------------------------------------------------------------------------
    function approveAndCall(address spender, uint tokens, bytes memory data) public returns(bool success) {
        require(!approveAndCallLock && whitelist[msg.sender],"Must be unlocked AND whitelisted");
        require(!blacklist[msg.sender], "Cannot be a Blacklisted account"); //do not approve the blacklisted address
        
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
        totalGasSpent+=tx.gasprice;
        return true;
    }
    

    // ------------------------------------------------------------------------
    // Don't accept ETH
    // ------------------------------------------------------------------------

    function () external payable {
        revert();
    }

    // ------------------------------------------------------------------------
    // Owner can transfer out any accidentally sent ERC20 tokens
    // ------------------------------------------------------------------------

    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns(bool success) {
        return ERC20Interface(tokenAddress).transfer(owner, tokens);
    }
    
//======================GETTERS===========================

     // ------------------------------------------------------------------------
    // Returns the amount of tokens approved by the owner that can be
    // transferred to the spender's account
    // ------------------------------------------------------------------------
    function allowance(address tokenOwner, address spender) public view returns(uint remaining) {
        return allowed[tokenOwner][spender];
    }   
    
    // ------------------------------------------------------------------------
    // Total supply
    // ------------------------------------------------------------------------
    function totalSupply() public view returns(uint) {
        return (tokensGenerated+tokensMined) - tokensBurned;
    }

    // ------------------------------------------------------------------------
    // Get the token balance for account `tokenOwner`
    // ------------------------------------------------------------------------
    function balanceOf(address tokenOwner) public view returns(uint balance) {
        return balances[tokenOwner];
    }
    
    
    //this is a recent ethereum block hash, used to prevent pre-mining future blocks
    function getChallengeNumber() public view returns(bytes32) {
        return challengeNumber;
    }

    //the number of zeroes the digest of the PoW solution requires.  Auto adjusts
    function getMiningDifficulty() public view returns(uint) {
        return _MAXIMUM_TARGET.div(miningTarget);
    }

    function getMiningTarget() public view returns(uint) {
        return miningTarget;
    }

 
    function getMiningReward() public view returns(uint) {
        return tokensBurned.div(50); //this is two percent of a burned tokens
    }

    //help debug mining software
    function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns(bytes32 digesttest) {
        bytes32 digest = keccak256(abi.encodePacked(challenge_number, msg.sender, nonce));
        return digest;
    }

    //help debug mining software
    function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns(bool success) {
        bytes32 digest = keccak256(abi.encodePacked(challenge_number, msg.sender, nonce));
        if (uint256(digest) > testTarget) revert();
        return (digest == challenge_digest);
    }
}
