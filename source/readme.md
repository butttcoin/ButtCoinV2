CURRENTLY UNDER CONSTRUCTION!


# ButtCoin Version 2.0 White Paper

### Introduction
The purpose of making this ERC20 token/coin is to create a cryptocurrency that is based on people’s beliefs regarding the Bitcoin. ButtCoin is by no means better or worse than a Bitcoin. It is simply different. ButtCoin was carefully brainstormed from various resources and stories about Bitcoin, and put together into a functioning contract. The resources are scattered, while referencing them would be a long-term project. Ethereum has provided us with an ability to make almost any functioning model of a cryptocurrency that we want, without worrying about the low-level priorities that concern coin’s survival. This coin is made as a proof that we can take almost any idea regarding the cryptocurrencies, even misconceptions, and create a product that might under-perform or even out-perform the Bitcoin. Furthermore, a different name could have been chosen. ButtCoin is a distortion of a BitCoin, and therefore a work of satire. Since the ButtCoin community was already formed prior to this coin, and since it is a community which enjoys a good satire, ButtCoin has been chosen as a name of this coin. 

The version 2.0 is taking the version 1.0 to a next level. The confusion that version 1.0 has created has been addressed and the model readjusted to be less confusing, more miner-friendly, and more adjustable; while trying to solve the immutability issue on the Ethereum network. The version 1.0 has been discontinued due to Ethereum's immutability. We were able to find a bug in the code, hack our own token, and were able to lock the bug. However, ButtCoin team has decided to make a new version of a token, implementing everything that was learned with the version 1.0. Version 1.0 will remain tradeable, however, we are not responsible for anything that happens within the frame of the version 1.0.

### Main differences, v1.0 versus v2.0

1. Mining is now making more sense, and has blocks. However, given the ability to be more precise using Solidity, we can adjust the rewards and difficulty after each block is mined. In essence, there is no difference between the block and era, however, it helps us keep a better track of statistics and calculations that can be done per era.

2. Each reward is 2% of the overall burned tokens minus the overall minted tokens. This means, more burning implies greater rewards. More mining implies lower rewards. The mining difficulty does not decrease. As the mining difficulty slowly increases, more burning will occur, and therefore, the rewards increase as the mining difficulty increases. This way we are still encouraging the smart mining.

3. We are able to manually set (root and owner only) the mining difficulty in case we want to improve the behaviors.

4. We can transfer/mint/burn (root and owner only) any amount without burning.

5. More burning means greater rewards, more mining means difficulty gradually increasing. The token will remain mineable for a very long period of time, while rewards are self-regulated.

6. We have a complete control of all public functions, and we can (un)lock them. This allows us to create any kind of a contract we want and still be able to use the same token.

7. We have the root, whitelist, and the blacklist. Root is one level lower from the account owner, and is to be used by the trusted accounts only. Whitelist allows us to add trusted accounts but not to allow them the root access. Blacklist are the accounts we have zero trust with.

8. Any blacklisted account that attemps a transfer will get all of their tokens burned.

9. Usual getters for the root, whitelist, blacklist, mining statistics, ... have been added.

10. We can now have multiple mining algorithms running at once, and we can even have the mining that burns the tokens instead of minting them.


## Code overview

### Statistical public variables
```blockCount``` - The number of blocks that were mined (how many times a reward was given)
```lastMiningOccured``` - When was the last reward given (timestamp)
```lastRewardAmount``` - How much was the last reward (including 8 decimals)
```lastRewardEthBlockNumber``` - The last ETH block number for the reward
```miningTarget``` - Current difficulty
```rewardEra``` - The current reward era
```tokensBurned``` - Overall number of burned tokens
```tokensGenerated``` - Overall number of generated tokens
```tokensMined``` - Overall number of mined tokens
```totalGasSpent``` - How much gas was spent, in total, since the contract got deployed
```challengeNumber``` - the challenge number ID
```lastRewardTo``` - who got the las mining reward
```lastTransferTo``` - who made the last transfer

### Statistical public maps
```allowed``` - The allowed tokens per address for a trasferFrom function
```balances``` - The amount of tokens per account
```solutionForChallenge``` - A collection of the mining solutions

### Public functions

``` js
addToBlacklist (address addToBlacklist)
```
Only the root accounts and the owner address can access this function. This function is used mainly to prevent the scammers from taking an advantage of a token. Furthermore, it prevents anyone from abusing the token in any undesireable way. If the input address is already on a blacklist, transaction cannot be processed, and error is displayed beforehand. For any other user other than root and admin, processing this function will also throw an error.

``` js
addToRootAccounts (address addToRoot)
```
Only the root accounts and the owner address can access this function. This function is used to enable the safe communication between the various contracts with a ButtCoin's main contract. Furthermore, it can be used as the storage of administrator accounts. If the input address is already a root, transaction cannot be processed, and error is displayed beforehand. For any other user other than root and admin, processing this function will also throw an error.

``` js
addToWhitelist (address addToWhitelist)
```
Only the root accounts and the owner address can access this function. This function is used to enable the safe communication between the various contracts with any other contract that requires the whitelist and is communicating with the main ButtCoin contract. If the input address is already whitelisted, transaction cannot be processed, and error is displayed beforehand. For any other user other than root and admin, processing this function will also throw an error.

``` js
allowance (address tokenOwner,address spender)
```
Returns the amount of tokens approved by the owner that can be transferred to the spender's account.


``` js
approve (address spender,uint tokens)
```
Token owner can approve for `spender` to transferFrom(...) `tokens`. The function must not be locked, and the token owner cannot be blacklisted. The spender cannot be the address(0).
     
``` js
approveAndCall (address spender,uint tokens,bytes memorydata)
```
Token owner can approve for `spender` to transferFrom(...) `tokens` from the token owner's account. The `spender` contract function `receiveApproval(...)` is then executed. The function must not be locked and the token owned must not be blacklisted.

``` js
confirmBlacklist (address confirmBlacklist)
```
Tells whether the address is blacklisted. True if yes, False if no. Anyone can execute this function.


``` js
confirmWhitelist (address tokenAddress)
```
Tells whether the address is whitelisted. True if yes, False if no. Anyone can execute this function.

``` js
decreaseAllowance (address spender,uint256 subtractedValue)
```
Decreases the allowance. The approve function must not be locked, and the initiator must not be blacklisted. Address(0) cannot be approved.

``` js
getBlockAmount (address minerAddress)
```
Tells how much was mined by an address.

``` js
getBlockAmount (uint blockNumber)
```
Tells how much was mined per block provided the blocknumber.  

``` js
getBlockMiner (uint blockNumber)
```
Tells which address mined the block provided the blocknumber.  


``` js
increaseAllowance (address spender, uint256 addedValue)
```
Increases the allowance. The approve function must not be locked, and the initiator must not be blacklisted. Address(0) cannot be approved.

``` js
mint (uint256 nonce, bytes32 challenge_digest)
```
Rewards the miners. The function must be unlocked. The contract initiator must not be blacklisted. The reward amount must not be a zero (otherwise it is wasting ETH gas). Overall amount of burned tokens must be less than 2^226.

``` js
multiTransfer (address[] memoryreceivers, uint256[] memoryamounts)
```
Allows the multiple transfers, initiates the '''transfer (addressto,uinttokens)''' function multiple times. Therefore, the rules are the same as in a transfer function.


``` js
removeFromBlacklist (address removeFromBlacklist)
```
Removes the account from a blacklist. Only the contract owner or the root accounts can call this function. Error is thrown when address is not blacklisted.
     
``` js
removeFromRootAccounts (address removeFromRoot)
```
Removes the account from a root account list. Only the contract owner or the root accounts can call this function. Errror is thrown if address is not a root address.

``` js
removeFromWhitelist (address removeFromWhitelist)
```
Removes the account from a whitelist. Only the contract owner or the root accounts can call this function. Error is thrown when address is not whitelisted.

``` js
rootTransfer (addressfrom, addressto, uint tokens)
```
Transfer without burning, can be used for minting new tokens as well as burning. Must be a contract owner or a root address. The function must be unlocked. This function is useful when creating the hybrid contracts with other tokens on a market so we can change the behaviour of the ButtCoin into anything we like.

``` js
setDifficulty (uint difficulty)
```
We can do a manual setting of a mining difficulty. This is to be used in emergency situations only. Only root and a contract owner can access this function.


``` js
transfer (addressto, uint tokens)
```
The transfer function which reduces 2% of a transaction. 1% is burned, and other 1% goes to a previous transfer initiator. It does not send the 1% to itself. Furthermore, if account is blacklisted, all of their tokens will be burned. This is to prevent the scammers from using a token in any undesired way. Function must be unlocked. The sender cannot be address(0), and the amount of tokens must be less than or equal to a current amount.

``` js
transferFrom (addressfrom,addressto,uinttokens)
```
The transfer of any amount of `tokens` from the `from` account to the `to` account. 1% of a transaction is burned, and other 1% goes to a previous transfer initiator. If the `from` is a blacklisted account, all of their tokens are burned instead. Function must be unlocked. The sender cannot be address(0), and the amount of tokens must be less than or equal to a current amount.

### View functions

``` js
balanceOf (addresstokenOwner)
```

``` js
checkMintSolution (uint256nonce,bytes32challenge_digest,bytes32challenge_number,uinttestTarget)
```

``` js
currentSupply ()
```

``` js
getChallengeNumber ()
```

``` js
getMiningDifficulty ()
```

``` js
getMiningReward ()
```

``` js
getMiningTarget ()
```

``` js
getMintDigest (uint256nonce,bytes32challenge_digest,bytes32challenge_number)
```

``` js
totalSupply ()
```

### Internal Functions
``` js 
_startNewMiningEpoch() 
```
Called by the constructor (only once) and by mint function every time we reward the tokens.


``` js 
reAdjustDifficulty() 
```
Called by ```_startNewMiningEpoch()```. Readjusts the difficulty levels. Every time the mining occurs, we remove the number from a miningTarget. Lower the miningTarget, greater the difficulty. The mining target starts at 2^234. We are subtracting 2^210 from a MiningTarget each time we mine a block. This means that we can mine the coin (approximately) 16,777,216 times. If it takes 1 minute to mine a coin, we can mine it for (approximately) 30 years. However, since the mining difficulty always increases, we can safely assume that it can be mined for several hundred years.



### Lock Switch Variables
   bool public approveAndCallLock = false; //we can lock the approve and call function
   bool public approveLock = false; //we can lock the approve function.
   bool public mintLock = false; //we can lock the mint function, for emergency only.
   bool public rootTransferLock = false; //we can lock the rootTransfer fucntion in case there is an emergency situation.
   bool public transferFromLock = false; //we can lock the transferFrom function in case there is an emergency situation.
   bool public transferLock = false; //we can lock the transfer function in case there is an emergency situation.

   bool internal constructorLock = false; //makes sure that constructor of the main is executed only once.
   mapping(address => bool) internal blacklist; //in case there are accounts that need to be blocked, good for preventing attacks (can be useful against ransomware).
   mapping(address => bool) internal rootAccounts; //for whitelisting the accounts such as exchanges, etc.
   mapping(address => bool) internal whitelist; //for whitelisting the accounts such as exchanges, etc.
   mapping(uint => address) internal blockMiner; //for keeping a track of who mined which block.
   mapping(uint => uint) internal blockAmount; //for keeping a track of how much was mined per block
   mapping(address => uint) internal minedAmount; //for keeping a track how much each miner earned

### Lock Switche Functions
``` js
switchApproveAndCallLock ()
```
``` js
switchApproveLock ()
```
``` js
switchMintLock ()
```
``` js
switchRootTransferLock ()
```
``` js
switchTransferFromLock ()
```
``` js
switchTransferLock ()
```
