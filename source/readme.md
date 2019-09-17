<p align="center">
  <img src="https://raw.githubusercontent.com/butttcoin/ButtCoinV2/master/source/Simplified_COIN.png" width="256" title="Logo">
</p>

For the less-technical questions and aswers, see the FAQ document: https://github.com/butttcoin/FAQ

# ButtCoin Version 2.0 White Paper
## 0x5556d6a283fD18d71FD0c8b50D1211C5F842dBBc

### Introduction
The purpose of making this ERC20 token/coin is to create a cryptocurrency that is based on people’s beliefs regarding the Bitcoin. ButtCoin is by no means better or worse than a Bitcoin. It is simply different. ButtCoin was carefully brainstormed from various resources and stories about Bitcoin, and put together into a functioning contract. The resources are scattered, while referencing them would be a long-term project. Ethereum has provided us with an ability to make almost any functioning model of a cryptocurrency that we want, without worrying about the low-level priorities that concern coin’s survival. This coin is made as a proof that we can take almost any idea regarding the cryptocurrencies, even misconceptions, and create a product that might under-perform or even out-perform the Bitcoin. Furthermore, a different name could have been chosen. ButtCoin is a distortion of a BitCoin, and therefore a work of satire. Since the ButtCoin community was already formed prior to this coin, and since it is a community which enjoys a good satire, ButtCoin has been chosen as a name of this coin. 

The version 2.0 is taking the version 1.0 to a next level. The confusion that version 1.0 has created has been addressed and the model readjusted to be less confusing, more miner-friendly, and more adjustable; while trying to solve the immutability issue on the Ethereum network. The version 1.0 has been discontinued due to Ethereum's immutability. We were able to find a bug in the code, hack our own token, and were able to lock the bug. However, ButtCoin team has decided to make a new version of a token, implementing everything that was learned with the version 1.0. Version 1.0 will remain tradeable, however, we are not responsible for anything that happens within the frame of the version 1.0.

### Token allocation
Since there are 33,554,431.99999981 minted tokens, 1/3 goes to a community, 1/3 to exchanges, 3/20 to developers, and the rest is probably going to be burned. There are 0 premined tokens, and tokens are mined only to recycle the burned amounts. 

### Explanation of a Design
- The core function of this token is the transfer function. The transfer function burns 1% of a total amount that is transfered, while another 1% goes to a previous sender. Sending the 1% to a previous sender is important since it brings a balance to a system and averages-out the overall token distribution. Furthermore, it may be enough to cover the transfer fees and perhaps give some extra rewards. If the previous sender is the same as the current sender, the 1% is not sent.

- The second main function is the mining algorithm. Briefly, the mining reward is always the 2% of the overall mined tokens subtracted from the overall burned tokens. In a sense, mining is equivalent to recycling the burned tokens. Furthermore, the mining difficulty is always increasing. This means that there will always be more tokens that were burned than mined. Also, it means that tokens will never completely burn-out and become the store of a value. It also means that miners must know when to mine this token, since it burns ETH gas and the rewards can decrease. Although rewards decrease with the recycled tokens, since difficulty is always increasing, it means that rewards will always increase with the increasing difficulty. A reward decrease is therefore temporary.

- Nevertheless, given the locks and root account lists, as well as the rootTransfer and the setDifficulty functions, we can design as many mining algorithms as we like, and make them work for the ButtCoin while overriding the old mining algorithm. We can use the mining procedure to decrease the difficulty, or to burn the tokens instead of minting them.

- There are zero pre-mined tokens. We have pre-minted (and not pre-mined) 33,554,431.99999981 tokens in order to distribute them to users who can't mine, and exchanges that ask for certain amounts of tokens in order to be listed. 1/3 is for the community, 1/3 is for the exchanges and 1/3 is for developers. We may give more to a community since we may not need so many tokens allocated to developers. Anything that is burned is for the miners to recycle. 

- Although the current and the total supply begun with 33,554,431.99999981 tokens, it is still possible to mine this token to infinity. Although it could take at least a decade to surpass the initial supply, it can still increase with the time. For this reason (although it may be confusing to some people) the current supply and the total supply always mean the same thing.

- The locks are made in order to override the functions in the sub-contracts avoiding a need for another 0xBUTT version.

- The blacklists also allow us to track the reported scammers and simply by putting an address onto a blacklist, a single transfer will burn their tokens, and they will pay for the ETH gas.

- The root account lists are to be used by the trusted administrators or the smart-contracts that interact with the main contract changing a design in some way. This can be used while distributing the tokens in some creative way, or while adding the multiple mining algorithms and/or overriding the old mining algorithm.

- The whitelist is the list to be used by the sub-contracts communicating with other sub-contracts.

- We are also keeping a track of the amount of the gas that was spent on this contract, so we can divide it by the number of circulating coins and derive the bottom market price.


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

### Static variables
```name``` - ButtCoin V2.0

```symbol``` - 0xBUTT

```decimals``` - 8

```_BLOCKS_PER_ERA``` - 20999999

```_MAXIMUM_TARGET``` - (2 ** 234), smaller the number means a greater difficulty

```_totalSupply``` - 33,554,431.99999981 tokens

### Statistical public variables
```blockCount``` - The number of blocks that were mined (how many times a reward was given).

```lastMiningOccured``` - When was the last reward given (timestamp).

```lastRewardAmount``` - How much was the last reward (including 8 decimals).

```lastRewardEthBlockNumber``` - The last ETH block number for the reward.

```miningTarget``` - Current difficulty.

```rewardEra``` - The current reward era.

```tokensBurned``` - Overall number of burned tokens.

```tokensGenerated``` - Overall number of generated tokens.

```tokensMined``` - Overall number of mined tokens.

```totalGasSpent``` - How much gas was spent, in total, since the contract got deployed.

```challengeNumber``` - The challenge number ID.

```lastRewardTo``` - Address that got the las mining reward.

```lastTransferTo``` - Address that made the last transfer.

### Statistical public maps
```allowed``` - The allowed tokens per address for a trasferFrom function.

```balances``` - The amount of tokens per account.

```solutionForChallenge``` - A collection of the mining solutions.


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
balanceOf (address tokenOwner)
```
Get the token balance for account `tokenOwner`.

``` js
currentSupply ()
```
Get the current supply, in this case same as the total supply.

``` js
getChallengeNumber ()
```
This is a recent ethereum block hash, used to prevent pre-mining future blocks.

``` js
getMiningDifficulty ()
```
Gets the mining difficulty as an integer. _MAXIMUM_TARGET/miningTarget

``` js
getMiningReward ()
```
Gets the mining reward.

``` js
getMiningTarget ()
```
Gets the mining target.

``` js
totalSupply ()
```
Get the total supply, in this case same as the current supply.

``` js
getMintDigest (uint256 nonce,bytes32 challenge_digest,bytes32 challenge_number)
```
For debug purposes only.

``` js
checkMintSolution (uint256 nonce,bytes32 challenge_digest,bytes32 challenge_number,uint testTarget)
```
For debug purposes only.


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
All switches are set to ``False`` by a default. False means unlocked, True means locked.

```approveAndCallLock``` - we can (un)lock the approve and call function.

```approveLock``` - we can (un)lock the approve function.

```mintLock``` - we can (un)lock the mint function, for emergency only.

```rootTransferLock``` - we can (un)lock the rootTransfer fucntion in case there is an emergency situation.

```transferFromLock``` - we can (un)lock the transferFrom function in case there is an emergency situation.

```transferLock``` - we can (un)lock the transfer function in case there is an emergency situation.

```constructorLock``` - called only once by the constructor so that the constructor can be executed only once.

### Internal Switch Maps
```blacklist``` - in case there are accounts that need to be blocked, good for preventing attacks (can be useful against ransomware). Good for preventing the scammers from abusing this token.

```rootAccounts``` - for communicating to sub-conctracts and having the root access.

```whitelist``` - for sub-contracts communicating to sub-conctracts.

```blockMiner``` - for keeping a track of which address mined which block.

```blockAmount``` - for keeping a track of how much was mined per block.

```minedAmount``` - for keeping a track how much each miner earned.

### Lock Switch Functions
``` js
switchApproveAndCallLock ()
```
Switches the approveAndCallLock from false to true or from true to false.

``` js
switchApproveLock ()
```
Switches the approveLock from false to true or from true to false.


``` js
switchMintLock ()
```
Switches the mintLock from false to true or from true to false.


``` js
switchRootTransferLock ()
```
Switches the rootTransferLock from false to true or from true to false.


``` js
switchTransferFromLock ()
```
Switches the transferFromLock from false to true or from true to false.


``` js
switchTransferLock ()
```
Switches the transferLock from false to true or from true to false.
