//THIS EMULATOR IS MADE FOR THE GRAPHS ONLY!
//For resembling real data, we need another code

public class v2emulator {

    public static void main(String[] args){

        //larger the number, lower the difficulty
        double lowestDifficulty = 100000; //just some large number
        double burnedTokens = 0; //we will start with a zero, then randomly increase
        double generatedTokens = 1000; //lets assume some number of mintedTokens
        double minedTokens = 0; //overall mined tokens, we start the mining from a zero
        double liveTokens = 1000; //same as generated

        double pastDifficulty = lowestDifficulty; //the previous difficulty value

        for(int t=0;t<1000;t++){ //1000 steps for the graphs to make some sense

            //assume there was some transfer of tokens and that burning happened.
            //lets say, not more than 10% of a total is burned each iteration
            double toBurnPercent = Math.random()*0.1;
            double toBurn = liveTokens*toBurnPercent;
            burnedTokens = burnedTokens+toBurn;
            liveTokens = liveTokens-toBurn;


            //get the sum of all tokens that ever existed
            double sumofall = burnedTokens+minedTokens+generatedTokens;

            //Lets see what the difficulty is
            double currentDifficulty = pastDifficulty - ((lowestDifficulty*burnedTokens)/sumofall);
            pastDifficulty = currentDifficulty;

            //now assume that we have mined the tokens and that epoch is over
            double mined = generatedTokens/2;
            liveTokens = liveTokens+mined;
            minedTokens = minedTokens+mined;

            //end of emulated era, print results
            //current difficulty is substracted from lowestDifficulty so that graphs can make sense (up is higher, down is lower)
            double incrDiff = (lowestDifficulty-currentDifficulty);
            System.out.println(burnedTokens+","+minedTokens+","+liveTokens+","+incrDiff);


        }



    }



}
