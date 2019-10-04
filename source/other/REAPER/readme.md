# Reaper Token White-Paper
## Overview

The reaper token's main goal is to introduce a new deflationary mechanism where addresses are burned. Deflation is usually achieved by burning 1% of any transfer. Reaper, on the other hand, is pruning the network by removing the least active accounts. The pruning is done by burning the assets of the least active account and transferring the 50% to a person who initiated the pruning. Thus, the initiator address is called The Reaper. Since we are pruning the network to achieve the best performance, we are also distributing and minting the tokens in a similar manner. For this reason, we have two cycles called Sowing and Reaping. Therefore, the main purpose of this token is to establish the best-performing network by distributing and burning the tokens. Once all tokens are minted and Sowing and Reaping periods over, we are simply applying the classical 1% burning fee to each transfer. We are hoping to accomplish the optimal parameters for any deflationary token, answering which ratio of minted and burned tokens would give the best token performance.


## Initial parameters
Since token is minted by transfers during the Sowing cycle, we have selected 21 accounts that will get 1000 tokens each to do whatever they want. These accounts can mint the tokens by making a transfer to any other account. We hope that they will transfer any number of tokens to people whom they can trust, so those people can start minting their own tokens.

## About 21 initial accounts
Since we asked for accounts that have more than 100 followers on a Twitter, we assume that they will network the token minting, and spread the tokens to any other account they can trust. Tokens are minted simply by sending any amount to any address. Initial reward is 14500 tokens, and every 512 transfers (after the Reaping cycle is finished) this reward gets reduced by a half. Furthermore, should they become inactive, their accounts will be reaped. We hope that at least one account will do the token distribution properly.


## Token data
- Symbol      :  REAP
- Name        :  The Reaper 
- Decimals    :  8
- Total supply:  20,862,499.99998474
- Permitted   :  6,000,000.00000000
- Exchanges allocation: 5,000,000.0000000 from the Permitted amount
- Developers allocation: 1,000,000.0000000 from the Permitted amount
- Minimum number of transfers until reaching the total supply: 40962
- Rewards are given within a 10 minutes period to a first account that makes a transfer.
- Rewards are halved every 512 transfers.
- Initial reward amount is 14500.00000000 tokens.
- Sow period lasts 512 transfers, then Reaping period begins.
- Reap period lasts 512 transfers, then Sowing period begins with the halved rewards.
- Reap period means burning the least active accounts and taking 50% of their possessions.
- The minting will continue for at least 0.5 years, or more, depending on a volume of transfers.
- Once the minting is done, all transfers will be normal with a 1% burning fee (without Sowing or Reaping).

## Ownership privileges
Since we keep a track of the most inactive accounts, to avoid burning tokens allocated for the exchange liquidity, we need a whitelist. Since there are white-listed accounts immune to Sowing and Reaping, we need an owner to determine those accounts. Therefore, owner as well as the exchanges will not be able be Reaped, and whitelisted accounts cannot do any sowing either.

## Early exchange listings
We will use the BambooRelay as well as the Uniswap to distribute tokens for the very cheap price, so that everyone can mint their own tokens, reap them or be reaped.



## Reaping and sowing mechanism
First, we will do the sowing, then reaping and then repeat the both until 21 million tokens are distributed burned in such a manner. Once 21 million is reached, we will start burning 1% from each transfer.

## Sowing mechanism
Any account that transfers a token can get a reward within a 10 minute frame after the last reward. 
The reward is going to be 14500 tokens and it will be rewarded by minting new tokens adding them to a current supply.
After the rewards were distributed 512 times, the halving will happen, and the reaping period will begin. 

## Reaping mechanism
Any account making a transfer will get 50% from the last inactive account while the last inactive account tokens will be burned to a zero! The sowing begins after 512 reaps. It is possible to reap every account if and only if we have 512 holders or less.

## Once everything is distributed
Once all tokens are distributed, we will begin applying the 1% burning fee reduction from each transfer.

## MAIN LOGIC
The logic of this token is based on selecting different transfer functions under different circumstances. The transfer contracts are:
- NormalTransfer
- BurnTransfer
- ReapTransfer
- SowTransfer

The transfer functions are selected either by the Transfers function.

### NormalTransfer contract
This is a contract which has the usual transfer function, just like any other ERC20 token. The internal functions are helping the sanity check deciding whether the transfer protocol is proper or not.

### BurnTransfer contract
The purpose of this contract is to apply 1% of a reduction (burning) fee for each transfer.

### ReapTransfer contract
This is a contract which reaps the least active accounts.

### SowTransfer contract
This contract simply rewards the sender every 10 minutes or less. The time-frame is a random value where 10 minutes is a maximum.

### Transfers contract
This contract decides which transfer contract to apply. It is done in a following manner:

- If the account is white-listed simply make a transfer
- If the have minted all of our tokens and sowing reward is 1 token, then apply the BurnTransfer
- If the Sowing cycle is not done, use the SowTransfer, otherwise switch to ReapTransfer
- If the Reaping cycle is not done, use the ReapTransfer, otherwise switch to SowTransfer


This is a plain-english whitepaper, please see the source code for any other details.

