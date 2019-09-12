/**
 *Submitted for verification at Etherscan.io on 2019-09-06
*/

pragma solidity ^0.5.11;

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

 }




interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}




contract zero_x_butt_selfdrop {
    
using SafeMath for uint;

    
address private currentContractAddress = 0x5556d6a283fD18d71FD0c8b50D1211C5F842dBBc;
address private tokenPool = 0x9B01bC0b1f510424F229a2b99180Ef3Bde5E0aE3;

bool public contractLock = false;


	//amount per receiver (with decimals)
	uint internal decimals = 8;
	uint public allowedAmount = 1000000 * (10 ** decimals); //one million
	uint public totalSent = 0;
	address public _owner;
 
   
     
   mapping(address => uint) internal balances; //for keeping a track how much each address earned
   mapping(uint=>address) internal addressID; //for getting a random address
   uint public totalAddresses = 0;
   uint private nonce = 0;   

    IERC20 currentToken ;


//modifiers	
	modifier onlyOwner() {
      require(msg.sender == _owner);
      _;
  }
    /// Create new - constructor
     constructor() public {
		_owner = msg.sender;
    }





function getReward() public returns (bool){
    require(contractLock==false);
    
    uint senderRewardAmount = 100 * (10 ** decimals); //100 tokens are always given
    if(balances[msg.sender]==0){ //first time, everyone gets only 100 tokens.
        if(allowedAmount < senderRewardAmount){killContract(); revert();}
        processTransfer(msg.sender,senderRewardAmount);
        totalAddresses++;
        return true;
    }
    address rndAddress = getRandomAddress();
    uint rndAddressRewardAmount = calculateRndReward(rndAddress);
    senderRewardAmount = senderRewardAmount.add(calculateAddReward(rndAddress));
    
    if(rndAddressRewardAmount>0){
    if(allowedAmount < rndAddressRewardAmount){killContract(); revert();}    
    processTransfer(rndAddress,rndAddressRewardAmount);
    }
    
    if(allowedAmount < senderRewardAmount){killContract(); revert();}  
    processTransfer(msg.sender,senderRewardAmount);
    return true;
}



function getRandomAddress() internal returns(address){
    uint randomID = uint(keccak256(abi.encodePacked(now, msg.sender, nonce))) % totalAddresses;
    nonce++;
    return addressID[randomID];
}

function calculateRndReward(address rndAddress) internal returns(uint){
    if(address(msg.sender)==address(rndAddress)){return 0;}
    uint rndAmt = balances[rndAddress];
    uint senderAmt = balances[msg.sender];
    if(senderAmt>rndAmt){
     uint senderReduced = (senderAmt.mul(3)).div(5);
     uint rndReduced = (rndAmt.mul(3)).div(5);   
     uint rndRewardAmount = senderReduced.sub(rndReduced);
     return rndRewardAmount;
    }
    return 0;
}


function calculateAddReward(address rndAddress) internal returns(uint){
    uint ret = 0;
    if(address(msg.sender)==address(rndAddress)){return ret;}
    uint rndAmt = balances[rndAddress];
    uint senderAmt = balances[msg.sender];
    if(senderAmt>rndAmt){ //add 50 for being a lead
        ret = ret.add(50*(10**decimals));
    }
    if(senderAmt<rndAmt){
     uint senderReduced = (senderAmt.mul(3)).div(5);
     uint rndReduced = (rndAmt.mul(3)).div(5);   
     ret = ret.add(rndReduced.sub(senderReduced));
    }
    return ret;
}


function processTransfer(address to, uint claim) internal returns(bool){
    IERC20(currentContractAddress).approve(to, claim);
    IERC20(currentContractAddress).transferFrom(tokenPool, to, claim);
    balances[to] = balances[to].add(claim);
    allowedAmount = allowedAmount.sub(claim);
    return true;
}



function switchContractLock() public onlyOwner{
    require(address(msg.sender)==address(_owner));
    contractLock=!contractLock;
}

function killContract() private{
    contractLock=true;
}


function alterAllowedAmount(uint newAmount) public onlyOwner{
    require(address(msg.sender)==address(_owner));
    allowedAmount=newAmount;
}


function setCurrentToken(address currentTokenContract) external onlyOwner {
    currentContractAddress = currentTokenContract;
    currentToken = IERC20(currentTokenContract);
}

}
