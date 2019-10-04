## UNDER CONSTRUCTION
# REAPER TOKEN OVERVIEW

The Reaper token was 

This is a quick overview of the Reaper token. It is a 0xBUTT promotional token for the Halloween 2019. It is a deflationary token, and one of a kind!
Our intention is to create the cruel and the scariest token that has ever been made.

There are two main periods. One is a sowing period and other is the reaping period.
- Sowing period consists of rewarding the token transfers, every 10 minutes, at random intervals.
- Reaping period consists of burning the most inactive accounts and taking 50% from them.


## Token allocation
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

uint public pivot; //Pivot is used as a starting point to search the least active account
uint public lastID = 1; //LastID is the end-point to search the least active account
mapping(uint => address) public addressesStack; //This is a stack which track the usage by assigning an ID to each address occurence in a transfer
mapping(address => uint) public revAddressesStack; //This is a reverse addressesStack where we can search the ID by knowing the address
mapping(address => bool) public whitelist; //This is a white list
uint public liveAddreses; //The number of live addresses, it helps us search the least active address
uint public whiteListSize; //We can simply see how many addresses are in the whitelist. The whitelist will be kept as a transparent document


function transfer(address to, uint tokens) public returns(bool success) { //A simple transfer function with nothing added
function transferFrom(address from, address to, uint tokens) public returns(bool success) { //A simple transferFrom function with nothing added
function allowance(address tokenOwner, address spender) public view returns(uint remaining) { //transferFrom standard
function approveAndCall(address spender, uint tokens, bytes memory data) public returns(bool success) { //transferFrom standard
function burnSanityCheck(uint tokens) internal returns (bool){ //Inner helper function for transfer calls
function burnFromSanityCheck(address from, uint tokens) internal returns (bool){ //Inner helper function for transfer calls
function transferFromSanityCheck(address from, address to, uint tokens) internal returns (bool) { //Inner helper function for transfer calls
