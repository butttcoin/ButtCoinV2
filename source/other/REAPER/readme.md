# Reaper Token White-Paper
## Overview

The reaper token's main goal is to introduce a new deflationary mechanism where addresses are burned. Deflation is usualy achieved by burning 1% of any transfer. Reaper, on the other hand, is pruning the network by removing the least active account. The pruning is done by burning the assets of the least active account and transfering the 50% to a person who initiated the pruning. Thus, the initiator address is called The Reaper. Since we are pruning the network to achieve the best performace, we are also distributing and minting the tokens in a similar manner. For this reason, we have two cycles called Sowing and Reaping. Therefore, the main purpose of this token is to establish the best-performing network by distributing and burning the tokens. Once all tokens are minted and Sowing and Reaping periods over, we are simply applying the classical 1% burning fee to each transfer. We are hoping to accomplish the optimal parameters for any deflaitonary token, answering which ratio of minted and burned tokens would give the best token performaces.

The reaper token idea originates from a quick conversation on a Telegram's ButtCoin channel where we were discussing accounts, while one user thougth that we are discussing the tokens with a burning applied. Soon, we have realized that burning the inactive accounts would be something new that hasn't been done before, and although cruel, it would be nice to have around the Halloween 2019 as a ButtCoin promotional token.

## Initial parameters
Since token is minted by transfers during the Sowing cycle, we have selected 21 accounts that will get 100 tokens each. These accounts can mint the tokens by making a transfer to any other account. We hope that they will transfer any number of tokens to people whom they can trust, so those people can start minting their own tokens.

## Token data
- Symbol      :  REAP
- Name        :  The Reaper 
- Decimals    :  8
- Total supply:  20,862,499.99998474
- PreMinted   :  6,000,000.00000000
- Exchanges allocation: 5,000,000.0000000 from the PreMinted amount
- Developers allocation: 1,000,000.0000000 from the PreMinted amount
- Minimum number of transfers until reaching the total supply: 40962
- Rewards are given within a 10 minutes period to a first account that makes a transfer.
- Rewards are halved every 512 transfers.
- Initial reward amount is 14500.00000000 tokens.
- Sow period lasts 512 transfers, then Reaping period begins.
- Reap period lasts 512 transfers, then Sowing period begins with the halved rewards.
- Reap period means burning the least active accounts and taking 50% of their possessions.
- The minting will continue for at least 0.5 years, or more, depending on a volume of transfers.
- Once the minting is done, all transfers will be normal with a 1% burning fee (without Sowing or Reaping).



We will leave 3-5 million for the owner account in order to be able to spread the tokens to exchanges for a liquidity.
We will have to make a white-list so that tokens on exchanges don't get burned.

## Token distribution
Only 21 accounts will be elligible to get them for free, others will have to take the smallest and the cheapest amount from either a relay or uniswap. This is simply because everyone can mint their own tokens during the sow period and because we are starting from a zero, (except the 3-5 mil tokens allocated to exchanges and a liquidity). The total supply is 21 million.

## Reaping and sowing mechanism
First, we will do the sowing, then reaping and then repeat the both until 21 million tokens are distributed burned in such a manner.
Once 21 million is reached, we will start burning 1% from each transfer.

## Sowing mechanism
Any account that transfers a token can get a reward within a 10 minute frame after the last reward. 
The reward is going to be 1000 tokens and it will be rewarded by minting new tokens adding them to a current supply.
After the rewards were distributed 256 times, the halving will happen, and the reaping period begins. We are using the ButtCoin transfer function, rewarding the last transfer 1% and burning 1% as well.

## Reaping mechanism
Any account making a transfer will get 50% from the last inactive account while the last inactive account tokens will be burned to a zero!
After 256 reaps, the sowing begins.

## Once everything is done
We will then apply the SNAYL mechanism with an automated buffer increase, which will safe-guard the token from being manipulated.


