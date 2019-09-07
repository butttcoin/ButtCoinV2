CURRENTLY UNDER CONSTRUCTION!


# ButtCoin Version 2.0 White Paper

The version 1 has been discontinued the support due to Ethereum's immutability. We were able to find a bug in the code, and were able to lock it. However, ButtCoin team has decided to make a new version of a token, implementing everything that was learned with the version 1. Version 1 will remain tradeable on token.store, and we are not responsible for anything that happens within the frame of the version 1.

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



