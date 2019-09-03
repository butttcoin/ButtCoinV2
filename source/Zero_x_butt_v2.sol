 pragma solidity 0.5 .11;

// 'ButtCoin' contract, version 2.0
// Website: http://www.0xbutt.com/
//
// Symbol      : ButtCoin
// Name        : 0xBUTT 
// Total supply: 33,259,978.69054417
// Decimals    : 8
//
// ----------------------------------------------------------------------------

// ============================================================================
// Safe maths
// ============================================================================
 
 library SafeMath {
   function add(uint256 a, uint256 b) internal pure returns(uint256) {
     uint256 c = a + b;
     require(c >= a, "SafeMath: addition overflow");
     return c;
   }

   function sub(uint256 a, uint256 b) internal pure returns(uint256) {
     return sub(a, b, "SafeMath: subtraction overflow");
   }

   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
     require(b <= a, errorMessage);
     uint256 c = a - b;
     return c;
   }

   function mul(uint256 a, uint256 b) internal pure returns(uint256) {
     if (a == 0) {
       return 0;
     }
     uint256 c = a * b;
     require(c / a == b, "SafeMath: multiplication overflow");
     return c;
   }

   function div(uint256 a, uint256 b) internal pure returns(uint256) {
     return div(a, b, "SafeMath: division by zero");
   }

   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
     require(b > 0, errorMessage);
     uint256 c = a / b;
     return c;
   }

   function mod(uint256 a, uint256 b) internal pure returns(uint256) {
     return mod(a, b, "SafeMath: modulo by zero");
   }

   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
     require(b != 0, errorMessage);
     return a % b;
   }
 }

// ============================================================================
// ERC Token Standard Interface
// ============================================================================
 
 contract ERC20Interface {

   function addToBlacklist(address toBlackList) public;
   function addToRootAccounts(address toRootAccount) public;
   function addToWhitelist(address toWhitelist) public;
   function allowance(address tokenOwner, address spender) public view returns(uint remaining);
   function approve(address spender, uint tokens) public returns(bool success);
   function approveAndCall(address spender, uint tokens, bytes memory data) public returns(bool success);
   function balanceOf(address tokenOwner) public view returns(uint balance);
   function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns(bool success);
   function confirmBlacklist(address tokenAddress) public returns(bool);
   function confirmWhitelist(address tokenAddress) public returns(bool);
   function currentSupply() public view returns(uint);
   function decreaseAllowance(address spender, uint256 subtractedValue) public returns(bool);
   function getChallengeNumber() public view returns(bytes32);
   function getMiningDifficulty() public view returns(uint);
   function getMiningReward() public view returns(uint);
   function getMiningTarget() public view returns(uint);
   function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns(bytes32);
   function increaseAllowance(address spender, uint256 addedValue) public returns(bool);
   function mint(uint256 nonce, bytes32 challenge_digest) public returns(bool success);
   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public;
   function removeFromBlacklist(address removeFromBlacklist) public;
   function removeFromRootAccounts(address removeRootAccount) public;
   function removeFromWhitelist(address removeFromWhitelist) public;
   function rootTransfer(address from, address to, uint tokens) public returns(bool success);
   function setDifficulty(uint difficulty) public returns(bool success);
   function switchApproveAndCallLock() public;
   function switchApproveLock() public;
   function switchMintLock() public;
   function switchRootTransferLock() public;
   function switchTransferFromLock() public;
   function switchTransferLock() public;
   function totalSupply() public view returns(uint);
   function transfer(address to, uint tokens) public returns(bool success);
   function transferFrom(address from, address to, uint tokens) public returns(bool success);

   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
   event Transfer(address indexed from, address indexed to, uint tokens);
   
 }

// ============================================================================
// Contract function to receive approval and execute function in one call
// ============================================================================
 
 contract ApproveAndCallFallBack {
   function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
 }

// ============================================================================
// Owned contract
// ============================================================================
 
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

// ============================================================================
// All booleans are false as a default. False means unlocked.
// Secures main functions of the gretest importance.
// ============================================================================
 
 contract Locks is Owned {
     
   //false means unlocked, answering the question, "is it locked ?"
   //no need to track the gas usage for functions in this contract.
   
   bool internal constructorLock = false; //makes sure that constructor of the main is executed only once.
   
   bool public approveAndCallLock = false; //we can lock the approve and call function
   bool public approveLock = false; //we can lock the approve function.
   bool public mintLock = false; //we can lock the mint function, for emergency only.
   bool public rootTransferLock = false; //we can lock the rootTransfer fucntion in case there is an emergency situation.
   bool public transferFromLock = false; //we can lock the transferFrom function in case there is an emergency situation.
   bool public transferLock = false; //we can lock the transfer function in case there is an emergency situation.

   mapping(address => bool) internal blacklist; //in case there are accounts that need to be blocked, good for preventing attacks (can be useful against ransomware).
   mapping(address => bool) internal rootAccounts; //for whitelisting the accounts such as exchanges, etc.
   mapping(address => bool) internal whitelist; //for whitelisting the accounts such as exchanges, etc.

// ----------------------------------------------------------------------------
// Switch for an approveAndCall function
// ----------------------------------------------------------------------------
   function switchApproveAndCallLock() public {
     assert(address(msg.sender) == address(owner) || rootAccounts[msg.sender]); //Only the contract owner OR root accounts can initiate it
     approveAndCallLock = !approveAndCallLock;
   }

// ----------------------------------------------------------------------------
// Switch for an approve function
// ----------------------------------------------------------------------------
   function switchApproveLock() public {
     assert(address(msg.sender) == address(owner) || rootAccounts[msg.sender]); //Only the contract owner OR root accounts can initiate it
     approveLock = !approveLock;
   }

// ----------------------------------------------------------------------------
// Switch for a mint function
// ----------------------------------------------------------------------------
   function switchMintLock() public {
     assert(address(msg.sender) == address(owner) || rootAccounts[msg.sender]); //Only the contract owner OR root accounts can initiate it
     mintLock = !mintLock;
   }

// ----------------------------------------------------------------------------
// Switch for a rootTransfer function
// ----------------------------------------------------------------------------
   function switchRootTransferLock() public {
     assert(address(msg.sender) == address(owner) || rootAccounts[msg.sender]); //Only the contract owner OR root accounts can initiate it
     rootTransferLock = !rootTransferLock;
   }

// ----------------------------------------------------------------------------
// Switch for a transferFrom function
// ----------------------------------------------------------------------------
   function switchTransferFromLock() public {
     assert(address(msg.sender) == address(owner) || rootAccounts[msg.sender]); //Only the contract owner OR root accounts can initiate it
     transferFromLock = !transferFromLock;
   }

// ----------------------------------------------------------------------------
// Switch for a transfer function
// ----------------------------------------------------------------------------
   function switchTransferLock() public {
     assert(address(msg.sender) == address(owner) || rootAccounts[msg.sender]); //Only the contract owner OR root accounts can initiate it
     transferLock = !transferLock;
   }


// ----------------------------------------------------------------------------
// Adds account to root
// ----------------------------------------------------------------------------
   function addToRootAccounts(address addRootAccount) public {
     assert(address(msg.sender) == address(owner) || rootAccounts[msg.sender]); //Only the contract owner OR root accounts can initiate it
     rootAccounts[addRootAccount] = true;
     blacklist[addRootAccount] = false;
   }
   
// ----------------------------------------------------------------------------
// Removes account from the root
// ----------------------------------------------------------------------------
   function removeFromRootAccounts(address removeRootAccount) public {
     assert(address(msg.sender) == address(owner) || rootAccounts[msg.sender]); //Only the contract owner OR root accounts can initiate it
     rootAccounts[removeRootAccount] = false;
   }

// ----------------------------------------------------------------------------
// Adds account from the whitelist
// ----------------------------------------------------------------------------
   function addToWhitelist(address addToWhitelist) public {
     assert(address(msg.sender) == address(owner) || rootAccounts[msg.sender]); //Only the contract owner OR root accounts can initiate it
     whitelist[addToWhitelist] = true;
     blacklist[addToWhitelist] = false;
   }

// ----------------------------------------------------------------------------
// Removes account from the whitelist
// ----------------------------------------------------------------------------
   function removeFromWhitelist(address removeFromWhitelist) public {
     assert(address(msg.sender) == address(owner) || rootAccounts[msg.sender]); //Only the contract owner OR root accounts can initiate it
     whitelist[removeFromWhitelist] = false;
   }

// ----------------------------------------------------------------------------
// Adds account to the blacklist
// ----------------------------------------------------------------------------
   function addToBlacklist(address addToBlacklist) public {
     assert(address(msg.sender) == address(owner) || rootAccounts[msg.sender]); //Only the contract owner OR root accounts can initiate it
     blacklist[addToBlacklist] = true;
     rootAccounts[addToBlacklist] = false;
     whitelist[addToBlacklist] = false;
   }

// ----------------------------------------------------------------------------
// Removes account from the blacklist
// ----------------------------------------------------------------------------
   function removeFromBlacklist(address removeFromBlacklist) public {
     assert(address(msg.sender) == address(owner) || rootAccounts[msg.sender]); //Only the contract owner OR root accounts can initiate it
     blacklist[removeFromBlacklist] = false;
   }


// ----------------------------------------------------------------------------
// Tells whether the address is blacklisted. True if yes, False if no.  
// ----------------------------------------------------------------------------
   function confirmBlacklist(address tokenAddress) public returns(bool) {
     assert(address(msg.sender) == address(owner) || rootAccounts[msg.sender]);
     return blacklist[tokenAddress];
   }

// ----------------------------------------------------------------------------
// Tells whether the address is whitelisted. True if yes, False if no.  
// ----------------------------------------------------------------------------
   function confirmWhitelist(address tokenAddress) public returns(bool) {
     assert(address(msg.sender) == address(owner) || rootAccounts[msg.sender]);
     return whitelist[tokenAddress];
   }

// ----------------------------------------------------------------------------
// Tells whether the address is a root. True if yes, False if no.  
// ----------------------------------------------------------------------------
   function confirmRoot(address tokenAddress) public returns(bool) {
     assert(address(msg.sender) == address(owner) || rootAccounts[msg.sender]);
     return rootAccounts[tokenAddress];
   }

 }

// ============================================================================
// Decalres dynamic data used in a main
// ============================================================================
 contract Stats {
     
   uint public blockCount; //number of 'blocks' mined
   uint public lastMiningOccured;
   uint public lastRewardAmount;
   uint public lastRewardEthBlockNumber;
   uint public latestDifficultyPeriodStarted;
   uint public miningTarget;
   uint public rewardEra;
   uint public tokensBurned;
   uint public tokensGenerated;
   uint public tokensMined;
   uint public totalGasSpent;
   
   bytes32 public challengeNumber; //generate a new one when a new reward is minted

   address public lastRewardTo;
   address public lastTransferTo = address(0);
 }

// ============================================================================
// Decalres the constant variables used in a main
// ============================================================================
 contract Constants {
   string public name;
   string public symbol;
   
   uint8 public decimals;

   uint public _BLOCKS_PER_ERA = 20999999;
   uint public _MAXIMUM_TARGET = 13479973333575319897333507543509815336818572211270286240551805124797; //a big number, smaller the number, greater the difficulty, assume this is 1% of burning
   uint public _totalSupply;
 }

// ============================================================================
// Decalres the maps used in a main
// ============================================================================
 contract Maps {
   mapping(address => mapping(address => uint)) allowed;
   mapping(address => uint) balances;
   mapping(bytes32 => bytes32) solutionForChallenge;
 }

// ============================================================================
// MAIN
// ============================================================================
 contract Zero_x_butt_v2 is ERC20Interface, Locks, Stats, Constants, Maps {
     
   using SafeMath for uint;
   event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);


// ------------------------------------------------------------------------
// Constructor
// ------------------------------------------------------------------------
   constructor() public onlyOwner {
     if (constructorLock) revert();
     constructorLock = true;

     decimals = 8;
     name = "0xxxx0x";
     symbol = "0xxxx0x";

     _totalSupply = 3325997869054417;
     blockCount = 0;
     challengeNumber = 0;
     lastMiningOccured = now;
     lastRewardAmount = 0;
     lastRewardTo = address(0);
     lastTransferTo = address(0);
     latestDifficultyPeriodStarted = block.number;
     rewardEra = 0;
     tokensBurned = 0;
     tokensGenerated = 3325997869054417; //33,259,978.69054417
     tokensMined = 0;
     totalGasSpent = 0;

     emit Transfer(address(0), owner, tokensGenerated);
     balances[owner] = tokensGenerated;
     _startNewMiningEpoch();

     totalGasSpent = totalGasSpent.add(tx.gasprice);
   }
   

   
   
//---------------------PUBLIC FUNCTIONS------------------------------------

// ------------------------------------------------------------------------
// Rewards the miners
// ------------------------------------------------------------------------
   function mint(uint256 nonce, bytes32 challenge_digest) public returns(bool success) {
     assert(!mintLock); //The function must be unlocked
     assert(!blacklist[msg.sender]); //"Blacklisted accounts cannot mint"

     uint reward_amount = getMiningReward();
     if (reward_amount == 0) revert(); // No zero rewards

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

     lastRewardTo = msg.sender;
     lastRewardAmount = reward_amount;
     lastRewardEthBlockNumber = block.number;
     _startNewMiningEpoch();

     emit Mint(msg.sender, reward_amount, blockCount, challengeNumber);
     balances[msg.sender] = balances[msg.sender].add(reward_amount);
     tokensMined = tokensMined.add(reward_amount);

     lastMiningOccured = now;

     totalGasSpent = totalGasSpent.add(tx.gasprice);
     return true;
   }

// ------------------------------------------------------------------------
// If we ever need to design a different mining algorithm...
// ------------------------------------------------------------------------
   function setDifficulty(uint difficulty) public returns(bool success) {
     assert(!blacklist[msg.sender]);
     assert(address(msg.sender) == address(owner) || rootAccounts[msg.sender]); //Must be an owner or a root account
     miningTarget = difficulty;
     totalGasSpent = totalGasSpent.add(tx.gasprice);
     return true;
   }
   
// ------------------------------------------------------------------------
// Allows the multiple transfers
// ------------------------------------------------------------------------
   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
     for (uint256 i = 0; i < receivers.length; i++) {
       transfer(receivers[i], amounts[i]);
     }
   }

// ------------------------------------------------------------------------
// Transfer the balance from token owner's account to `to` account
// ------------------------------------------------------------------------
   function transfer(address to, uint tokens) public returns(bool success) {
     assert(tokens <= balances[msg.sender]); //Amount of tokens exceeded the maximum
     assert(transferLock || !whitelist[msg.sender]); //The function must be unlocked OR the account whitelisted

     if (blacklist[msg.sender]) {
       //we do not process a transfer for the blacklisted accounts, instead we burn their tokens.
       balances[msg.sender] = balances[msg.sender].sub(tokens);
       balances[address(0)] = balances[address(0)].add(tokens);
       emit Transfer(msg.sender, address(0), tokens);
       tokensBurned = tokensBurned.add(tokens);
     } else {
       uint toBurn = tokens.div(100); //this is a 1% of the tokens amount
       uint toPrevious = toBurn; //we send 1% to a previous account as well
       uint toSend = tokens.sub(toBurn.add(toPrevious));

       balances[msg.sender] = balances[msg.sender].sub(tokens);

       balances[to] = balances[to].add(toSend);
       emit Transfer(msg.sender, to, toSend);

       balances[lastTransferTo] = balances[lastTransferTo].sub(toPrevious);
       if (address(msg.sender) != address(lastTransferTo)) { //there is no need to send the 1% to yourself
         emit Transfer(msg.sender, lastTransferTo, toPrevious);
       }

       balances[address(0)] = balances[address(0)].add(toBurn);
       emit Transfer(msg.sender, address(0), toBurn);
       tokensBurned = tokensBurned.add(toBurn);

       lastTransferTo = to;
     }

     totalGasSpent = totalGasSpent.add(tx.gasprice);
     return true;
   }

// ------------------------------------------------------------------------
// Transfer without burning
// ------------------------------------------------------------------------
   function rootTransfer(address from, address to, uint tokens) public returns(bool success) {
     assert(!rootTransferLock && (address(msg.sender) == address(owner) || rootAccounts[msg.sender]));

     balances[from] = balances[from].sub(tokens);
     balances[to] = balances[to].add(tokens);
     emit Transfer(from, to, tokens);

     if (address(from) == address(0)) {
       tokensGenerated = tokensGenerated.add(tokens);
     }

     if (address(to) == address(0)) {
       tokensBurned = tokensBurned.add(tokens);
     }

     totalGasSpent = totalGasSpent.add(tx.gasprice);
     return true;
   }

// ------------------------------------------------------------------------
// Token owner can approve for `spender` to transferFrom(...) `tokens`
// ------------------------------------------------------------------------
   function approve(address spender, uint tokens) public returns(bool success) {
     assert(!approveLock && !blacklist[msg.sender]); //Must be unlocked and not blacklisted
     assert(spender != address(0)); //Cannot approve for address(0)
     allowed[msg.sender][spender] = tokens;
     emit Approval(msg.sender, spender, tokens);
     totalGasSpent = totalGasSpent.add(tx.gasprice);
     return true;
   }
   
// ------------------------------------------------------------------------
//Increases the allowance
// ------------------------------------------------------------------------
   function increaseAllowance(address spender, uint256 addedValue) public returns(bool) {
     assert(!approveLock && !blacklist[msg.sender]); //Must be unlocked and not blacklisted
     assert(spender != address(0)); //Cannot approve for address(0)
     allowed[msg.sender][spender] = (allowed[msg.sender][spender].add(addedValue));
     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
     totalGasSpent = totalGasSpent.add(tx.gasprice);
     return true;
   }
   
// ------------------------------------------------------------------------
// Decreases the allowance
// ------------------------------------------------------------------------
   function decreaseAllowance(address spender, uint256 subtractedValue) public returns(bool) {
     assert(!approveLock && !blacklist[msg.sender]); //Must be unlocked and not blacklisted
     assert(spender != address(0)); //Cannot approve for address(0)
     allowed[msg.sender][spender] = (allowed[msg.sender][spender].sub(subtractedValue));
     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
     totalGasSpent = totalGasSpent.add(tx.gasprice);
     return true;
   }
   
// ------------------------------------------------------------------------
// Transfer `tokens` from the `from` account to the `to` account
// ------------------------------------------------------------------------
   function transferFrom(address from, address to, uint tokens) public returns(bool success) {
     assert(!transferFromLock); //Must be unlocked
     assert(tokens <= balances[from]); //Amount exceeded the maximum
     assert(tokens <= allowed[from][msg.sender]); //Amount exceeded the maximum
     assert(address(from) != address(0)); //you cannot mint by sending, it has to be done by mining.

     if (blacklist[from]) {
       //we do not process a transfer for the blacklisted accounts, instead we burn their tokens.
       balances[from] = balances[from].sub(tokens);
       balances[address(0)] = balances[address(0)].add(tokens);
       emit Transfer(from, address(0), tokens);
       tokensBurned = tokensBurned.add(tokens);
     } else {
       uint toBurn = tokens.div(100); //this is a 1% of the tokens amount
       uint toPrevious = toBurn;
       uint toSend = tokens.sub(toBurn.add(toPrevious));

       balances[from] = balances[from].sub(tokens);
       allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);

       balances[to] = balances[to].add(toSend);
       balances[lastTransferTo] = balances[lastTransferTo].add(toBurn);
       balances[address(0)] = balances[address(0)].add(toBurn);

       emit Transfer(from, to, toSend);
       if (address(from) != address(lastTransferTo)) { //there is no need to send the 1% to yourself
         emit Transfer(from, lastTransferTo, toPrevious);
       }

       emit Transfer(from, address(0), toBurn);
       tokensBurned = tokensBurned.add(toBurn);

       lastTransferTo = to;

       totalGasSpent = totalGasSpent.add(tx.gasprice);
     }
     return true;
   }

// ------------------------------------------------------------------------
// Token owner can approve for `spender` to transferFrom(...) `tokens`
// from the token owner's account. The `spender` contract function
// `receiveApproval(...)` is then executed
// ------------------------------------------------------------------------
   function approveAndCall(address spender, uint tokens, bytes memory data) public returns(bool success) {
     assert(!approveAndCallLock && !blacklist[msg.sender]); //Must be unlocked, cannot be a blacklisted

     allowed[msg.sender][spender] = tokens;
     emit Approval(msg.sender, spender, tokens);
     ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
     totalGasSpent = totalGasSpent.add(tx.gasprice);
     return true;
   }

//---------------------INTERNAL FUNCTIONS---------------------------------  

// ----------------------------------------------------------------------------
// A new block epoch to be mined
// ----------------------------------------------------------------------------
   function _startNewMiningEpoch() internal {
    blockCount = blockCount.add(1);

     if ((blockCount.mod(_BLOCKS_PER_ERA) == 0)) {
       rewardEra = rewardEra + 1;
     }

     //we are always readjusting the difficulty
     _reAdjustDifficulty();

     //make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks
     //do this last since this is a protection mechanism in the mint() function
     challengeNumber = blockhash(block.number - 1);
   }
   
// ----------------------------------------------------------------------------
// Readjusts the difficulty levels
// ----------------------------------------------------------------------------
   function _reAdjustDifficulty() internal {
     uint reward = getMiningReward();
     uint difficultyExponent = toDifficultyExponent(reward);
     miningTarget = (2 ** difficultyExponent); //estimated

     latestDifficultyPeriodStarted = block.number;

     if (miningTarget > _MAXIMUM_TARGET) //very easy
     {
       miningTarget = _MAXIMUM_TARGET;
     }
   }   
   
// ----------------------------------------------------------------------------
// Find the exponent to convert tokens to a difficulty
// ----------------------------------------------------------------------------
   function toDifficultyExponent(uint tokens) internal returns(uint) {
     for (uint t = 0; t < 232; t++) {
       if ((t ** 3) * (10 ** uint(decimals)) >= tokens) return 232 - t;
     }
     return 0;
   }
   
//---------------------VIEW FUNCTIONS-------------------------------------  

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
     return _totalSupply;
   }

// ------------------------------------------------------------------------
// Current supply
// ------------------------------------------------------------------------
   function currentSupply() public view returns(uint) {
     return (tokensGenerated.add(tokensMined)).sub(tokensBurned);
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

   //returns the mining target
   function getMiningTarget() public view returns(uint) {
     return miningTarget;
   }

   //gets the mining reward
   function getMiningReward() public view returns(uint) {
     uint reward_amount = tokensBurned.div(50); //this is two percent of burned tokens

     //the reward sum must not be greater than the generated amount of tokensGenerated
     if (reward_amount.add(currentSupply()) > totalSupply()) {
       reward_amount = totalSupply().sub(currentSupply());
     }
     if (reward_amount < 1024) {
       reward_amount = 0; // no dust mining
     }

     return reward_amount;
   }
   
//---------------------EXTERNAL FUNCTIONS----------------------------------

// ------------------------------------------------------------------------
// Don't accept ETH
// ------------------------------------------------------------------------
   function () external payable {
     revert();
   }
   
//---------------------OTHER-----------------------------------------------   

// ------------------------------------------------------------------------
// Owner can transfer out any accidentally sent ERC20 tokens
// ------------------------------------------------------------------------
   function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns(bool success) {
     return ERC20Interface(tokenAddress).transfer(owner, tokens);
   }
// ------------------------------------------------------------------------
//help debug mining software
// ------------------------------------------------------------------------
   function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns(bytes32 digesttest) {
     bytes32 digest = keccak256(abi.encodePacked(challenge_number, msg.sender, nonce));
     return digest;
   }
// ------------------------------------------------------------------------
//help debug mining software
// ------------------------------------------------------------------------
   function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns(bool success) {
     bytes32 digest = keccak256(abi.encodePacked(challenge_number, msg.sender, nonce));
     if (uint256(digest) > testTarget) revert();
     return (digest == challenge_digest);
   }
 }
