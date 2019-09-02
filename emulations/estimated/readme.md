This is the estimated model of 0xBUTT distribution. We are mainly concerned with the live versus burned tokens and whether the coin can stay alive forever. The problem we are trying to solve is to have the coin that can be mined to infinity and burned to infinity as well. However, the burned amount must always be greater than the number of live tokens.

A more complicated model can be derived, however, given the max number for solidity 'uint', it will be hard to calculate anything without a heap overflow or large digits displaying as a data.

This is a small-sized hypothetical model test.

Since we are generating a difficulty according to amount of burned tokens (versus all other amounts), it can never be predicted what the future economics of this token may hold.  However, we can derive a moel to make sure that the token is deflationary by its nature.

See the Java file to find out the basic mechanics and how the numbers were derived.

See these graphs to confirm the deflationary nature of the token.


