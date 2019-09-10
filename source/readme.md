CURRENTLY UNDER CONSTRUCTION!


# ButtCoin Version 2.0 White Paper

### Introduction
The purpose of making this ERC20 token/coin is to create a cryptocurrency that is based on people’s beliefs regarding the Bitcoin. ButtCoin is by no means better or worse than a Bitcoin. It is simply different. ButtCoin was carefully brainstormed from various resources and stories about Bitcoin, and put together into a functioning contract. The resources are scattered, while referencing them would be a long-term project. Ethereum has provided us with an ability to make almost any functioning model of a cryptocurrency that we want, without worrying about the low-level priorities that concern coin’s survival. This coin is made as a proof that we can take almost any idea regarding the cryptocurrencies, even misconceptions, and create a product that might under-perform or even out-perform the Bitcoin. Furthermore, a different name could have been chosen. ButtCoin is a distortion of a BitCoin, and therefore a work of satire. Since the ButtCoin community was already formed prior to this coin, and since it is a community which enjoys a good satire, ButtCoin has been chosen as a name of this coin. 

The version 2.0 is taking the version 1.0 to a next level. The confusion that version 1.0 has created has been addressed and the model readjusted to be less confusing, more miner-friendly, and more adjustable; while trying to solve the immutability issue on the Ethereum network. The version 1.0 has been discontinued due to Ethereum's immutability. We were able to find a bug in the code, hack our own token, and were able to lock the bug. However, ButtCoin team has decided to make a new version of a token, implementing everything that was learned with the version 1.0. Version 1.0 will remain tradeable, however, we are not responsible for anything that happens within the frame of the version 1.0.

### Main differences, v1.0 versus v2.0

1. Mining is now making more sense, and has blocks. 

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

Let us start with the public functions:

``` js
addToBlacklist (addressaddToBlacklist)
```
``` js
addToRootAccounts (addressaddToRoot)
```
``` js
addToWhitelist (addressaddToWhitelist)
```
``` js
allowance (addresstokenOwner,addressspender)
```
``` js
approve (addressspender,uinttokens)
```
``` js
approveAndCall (addressspender,uinttokens,bytesmemorydata)
```
``` js
balanceOf (addresstokenOwner)
```
``` js
checkMintSolution (uint256nonce,bytes32challenge_digest,bytes32challenge_number,uinttestTarget)
```
``` js
confirmBlacklist (addressconfirmBlacklist)
```
``` js
confirmWhitelist (addresstokenAddress)
```
``` js
currentSupply ()
```
``` js
decreaseAllowance (addressspender,uint256subtractedValue)
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
getBlockAmount (addressminerAddress)
```
``` js
getBlockAmount (uintblockNumber)
```
``` js
getBlockMiner (uintblockNumber)
```
``` js
increaseAllowance (addressspender,uint256addedValue)
```
``` js
mint (uint256nonce,bytes32challenge_digest)
```
``` js
multiTransfer (address[]memoryreceivers,uint256[]memoryamounts)
```
``` js
removeFromBlacklist (addressremoveFromBlacklist)
```
``` js
removeFromRootAccounts (addressremoveFromRoot)
```
``` js
removeFromWhitelist (addressremoveFromWhitelist)
```
``` js
rootTransfer (addressfrom,addressto,uinttokens)
```
``` js
setDifficulty (uintdifficulty)
```
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
``` js
totalSupply ()
```
``` js
transfer (addressto,uinttokens)
```
``` js
transferFrom (addressfrom,addressto,uinttokens)
```