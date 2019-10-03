/**
 *Submitted for verification at Etherscan.io on 2019-06-17
*/

pragma solidity 0.5.11;
                                                                                                                 
// Mineable & Deflationary ERC20 Token using Proof Of Work
//
// Symbol      :  
// Name        :   
// Total supply: 21,000,000.00
// Decimals    : 8
//
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// Safe maths
// ----------------------------------------------------------------------------

library SafeMath {

    function add(uint a, uint b) internal pure returns(uint c) {
        c = a + b;
        require(c >= a);
    }

    function sub(uint a, uint b) internal pure returns(uint c) {
        require(b <= a);
        c = a - b;
    }

    function mul(uint a, uint b) internal pure returns(uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }

    function div(uint a, uint b) internal pure returns(uint c) {
        require(b > 0);
        c = a / b;
    }

}


// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
// ----------------------------------------------------------------------------

contract ERC20Interface {
    function totalSupply() public view returns(uint);
    function balanceOf(address tokenOwner) public view returns(uint balance);
    function allowance(address tokenOwner, address spender) public view returns(uint remaining);

}

contract TransfersInterface {
    function transfer(address to, uint tokens) public returns(bool success);
    function transferFrom(address from, address to, uint tokens) public returns(bool success);
    
    function approve(address spender, uint tokens) public returns(bool success);
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}


// ----------------------------------------------------------------------------
// Contract function to receive approval and execute function in one call
//
// Borrowed from MiniMeToken
// ----------------------------------------------------------------------------

contract ApproveAndCallFallBack {

    function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;

}

// ----------------------------------------------------------------------------
// Owned contract
// ----------------------------------------------------------------------------

contract Owned {

    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }

    function acceptOwnership() public {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }

}


contract NormalTransfer is TransfersInterface {
    using SafeMath for uint;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    uint public _totalSupply;
    uint public _currentSupply;
    
    
    function transfer(address to, uint tokens) public returns(bool success) {
        require(tokens>0);
        require(balances[msg.sender]>=tokens);
        require(address(to)!=address(msg.sender));
        require(address(to)!=address(0));
        require(msg.sender!=address(0));
        
        balances[msg.sender] = balances[msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }
    
    
    function burn(uint tokens) public returns(bool success) {
        require(tokens>0);
        require(balances[msg.sender]>=tokens);
        require(msg.sender!=address(0));
         
        balances[msg.sender] = balances[msg.sender].sub(tokens);
        _totalSupply.sub(tokens);
        emit Transfer(msg.sender, address(0), tokens);
        return true;
    }
    
    function burnFrom(address from, uint tokens) public returns(bool success) {
        assert(tokens>0);
        assert(balances[from]>=tokens);
        assert(from!=address(0));
        assert(tokens <= allowed[from][msg.sender]);
         
        emit Transfer(from, address(0), tokens);
        balances[from] = balances[from].sub(tokens);
        _totalSupply.sub(tokens);
        return true;
    }
 
    function approve(address spender, uint tokens) public returns(bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) public returns(bool success) {
        assert(tokens>0);
        assert(balances[from]>=tokens);
        assert(address(to)!=address(from));
        assert(from!=address(0));
        assert(tokens <= allowed[from][msg.sender]);
        assert(address(to) != address(0));

        balances[from] = balances[from].sub(tokens);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(from, to, tokens);
        return true;
    }

    function allowance(address tokenOwner, address spender) public view returns(uint remaining) {
        return allowed[tokenOwner][spender];
    }

    function approveAndCall(address spender, uint tokens, bytes memory data) public returns(bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
        return true;
    }  
}

contract BurnTransfer is NormalTransfer {
    function transfer(address to, uint tokens) public returns(bool success) {
        uint burn = tokens.div(100);
        NormalTransfer.transfer(to,tokens.sub(burn));
        NormalTransfer.transfer(address(0),burn);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) public returns(bool success) {
        uint burn = tokens.div(100);
        NormalTransfer.transferFrom(from,to,tokens.sub(burn));
        NormalTransfer.transferFrom(from,address(0),burn);
        return true;
    }
}

contract ButtCoinTransfer is NormalTransfer {
     address public prevButtAddress = address(0);
     
    function transfer(address to, uint tokens) public returns(bool success) {
        uint burn = tokens.div(100);
        NormalTransfer.transfer(to,(tokens.sub(burn)).sub(burn));
        if(address(msg.sender)!=address(prevButtAddress)){NormalTransfer.transfer(prevButtAddress,burn);}
        NormalTransfer.transfer(address(0),burn);
        prevButtAddress = msg.sender;
        return true;
    }
    
    function transferFrom(address from, address to, uint tokens) public returns(bool success) {
        uint burn = tokens.div(100);
        NormalTransfer.transferFrom(from,to,(tokens.sub(burn)).sub(burn));
        if(address(from)!=address(prevButtAddress)){NormalTransfer.transfer(prevButtAddress,burn);}
        NormalTransfer.transferFrom(from,address(0),burn);
        prevButtAddress = from;
        return true;
    }
}

contract SNAYLTransfer is NormalTransfer {
    uint private nonce = 0;    
    uint lengthOfArray = 3;
    address[] private fromArr;
    address[] private toArr;
    uint[] private amt;
    
   function getRandomID() internal returns (uint){
      uint randomnumber = uint(keccak256(abi.encodePacked(now, msg.sender, nonce))) % lengthOfArray;
      nonce++;
      return randomnumber;
  }    
  
  function changeLength(uint newLength) internal returns(bool){
    fromArr.length = newLength;
    toArr.length = newLength;
    amt.length = newLength;
    lengthOfArray = newLength;
    return true;
  }
  
  function autoBuffer() internal{
      uint r = getRandomID();
        if(fromArr[lengthOfArray-1]!=address(0)){
            changeLength(lengthOfArray.add(1));
        }
        else{
            changeLength(lengthOfArray.sub(1));
        }
  }
    
  function internalTransfer(address from, address to, uint256 tokens) internal returns(bool){
    autoBuffer(); //automatically adjust the buffer size
    
    //reduce the balances
    balances[from] = balances[from].sub(tokens);
    
    
    //get the data from array
    uint rnd = getRandomID();
    address fromaddr = fromArr[rnd];
    address toaddr = toArr[rnd];
    uint amtAddr = amt[rnd];
    
    //insert new data to array
    fromArr[rnd] = from;
    toArr[rnd] = to;
    amt[rnd] = tokens;
    
    
    //calculate the costs
    uint fee = amtAddr.div(100);
    uint send = amtAddr.sub(fee);
    
    //make transfers
        if(send>0){
            balances[toaddr] = balances[toaddr].add(send);
            NormalTransfer.transferFrom(fromaddr, toaddr, send);
        }
        if(fee>0){ 
            NormalTransfer.transferFrom(fromaddr, from, fee);
        }
    return true;
  }
  
  function transfer(address to, uint256 tokens) public returns (bool) {
    internalTransfer(msg.sender, to, tokens);
    return true;
  }

  function transferFrom(address from, address to, uint256 tokens) public returns (bool) {
    internalTransfer(from, to, tokens);
    allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
    return true;
  }
}

contract ReapTransfer is NormalTransfer{
    uint pivot;
    uint lastID = 1;
    mapping(uint=>address) addressesStack;
    mapping(address=>uint) revAddressesStack;
    mapping(address=>bool) whitelist;
    uint private liveAddreses;
    uint private whiteListSize;
    address public nextReap;
    

   function addToWhiteList(address toImmortals) public{
       whitelist[toImmortals] = true;
       whiteListSize++;
   }
   
   function removeFromWhitelist(address toMortals) public{
        whitelist[toMortals] = false;
        whiteListSize--;
   }
   
  function getNextMortalAddress() public view returns (address){
    if(liveAddreses.sub(whiteListSize)==0) return address(0);
    if(pivot==lastID) return address(0);
    
    uint tmpPivot = pivot;
    for(;tmpPivot<=lastID;tmpPivot++){
        address pivotAddress = addressesStack[tmpPivot];
        if(pivotAddress!=address(0) && !whitelist[pivotAddress]){
            return addressesStack[tmpPivot];
        }
    }
    return address(0);
  } 
  
  function reapTheMortal(address mortal) internal{
      if(!whitelist[mortal]){
      
      uint sumOf = balances[mortal].div(2);
      if(sumOf==0){
         NormalTransfer.burnFrom(mortal,balances[mortal]); 
      }
      else{
         NormalTransfer.transfer(mortal,sumOf);
         NormalTransfer.burnFrom(mortal,sumOf); 
      }
      liveAddreses--;
      }
  }
          
  function transfer(address to, uint256 tokens) public returns (bool) {
    if(revAddressesStack[msg.sender]==0){
        liveAddreses++;
        lastID++;
    }
    
    if(revAddressesStack[to]==0){
        liveAddreses++;
        lastID++;
    }
    

    revAddressesStack[msg.sender] = lastID;
    lastID++;
    revAddressesStack[to] = lastID; 
    
    address nextMortal = getNextMortalAddress();
    pivot = revAddressesStack[nextMortal];
    reapTheMortal(nextMortal);
    
    NormalTransfer.transfer(to, tokens);

    return true;
  }
  
  
  
  
  function transferFrom(address from, address to, uint256 tokens) public returns (bool) {
    if(revAddressesStack[msg.sender]==0){
        liveAddreses++;
        lastID++;
    }
    
    if(revAddressesStack[to]==0){
        liveAddreses++;
        lastID++;
    }
    
    if(revAddressesStack[from]==0 && (address(from)!=address(msg.sender))){
        liveAddreses++;
        lastID++;
    }
    

    revAddressesStack[msg.sender] = lastID;
    lastID++; revAddressesStack[to] = lastID; 
    if(address(from)!=address(msg.sender)){
     lastID++; revAddressesStack[from] = lastID;    
    }
    
    address nextMortal = getNextMortalAddress();
    pivot = revAddressesStack[nextMortal];
    reapTheMortal(nextMortal);
    
    NormalTransfer.transferFrom(from, to, tokens);

    return true;
  }

}

contract SowTransfer is ButtCoinTransfer{
    uint public sowReward = 1000;
    uint timeStamp = now;
    uint private nonce;
    
  function nextInterval() internal{
      uint maxSeconds = 500;
      uint randomnumber = uint(keccak256(abi.encodePacked(now, msg.sender, nonce))) % maxSeconds;
      nonce++;
      timeStamp = now+randomnumber;
  } 
  
  
  function transfer(address to, uint256 tokens) public returns (bool) {
    ButtCoinTransfer.transfer(to, tokens);
    if(now>timeStamp){
        mint(msg.sender, sowReward);
        nextInterval();
    }
    return true;
  }

  function transferFrom(address from, address to, uint256 tokens) public returns (bool) {
    ButtCoinTransfer.transferFrom(from, to, tokens);
    if(now>timeStamp){
        mint(from, sowReward);
        nextInterval();
    }
    return true;
  }
  
  function mint(address rewardAddress, uint sowReward) internal returns (bool) {
      emit Transfer(address(0), rewardAddress, sowReward);
      _currentSupply = _currentSupply+sowReward;
  }
  
  
    
}

contract Transfers is NormalTransfer, BurnTransfer, SNAYLTransfer, ReapTransfer, SowTransfer{
    
    //This part controls which transfer is called, and the reward amount
    uint public typeOfTransfer = 0; //0 is sow, 1 is reap, 2 is SNAYL
    
}

// ----------------------------------------------------------------------------
// REAPER, MAIN CONTRACT
// ----------------------------------------------------------------------------

contract REAEPER is ERC20Interface, Owned, Transfers {

    using SafeMath for uint;

    string public symbol;
    string public name;
    uint8 public decimals;
    
    bytes32 public challengeNumber; //generate a new one when a new reward is minted
    bool locked = false;

    uint public burnPercent;

 
    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------

    constructor() public onlyOwner {
        symbol = "REAP";
        name = "The Reaper";
        decimals = 8;
        _totalSupply = 21000000 * 10 ** uint(decimals);
        if (locked) revert();
        locked = true;
        burnPercent = 10; //it's divided by 1000, then 10/1000 = 0.01 = 1%
    }

 
 

    // ------------------------------------------------------------------------
    // Total supply
    // ------------------------------------------------------------------------

    function totalSupply() public view returns(uint) {
        return _totalSupply - balances[address(0)];
    }

    // ------------------------------------------------------------------------
    // Get the token balance for account `tokenOwner`
    // ------------------------------------------------------------------------

    function balanceOf(address tokenOwner) public view returns(uint balance) {
        return balances[tokenOwner];
    }



    // ------------------------------------------------------------------------
    // Don't accept ETH
    // ------------------------------------------------------------------------

    function () external payable {
        revert();
    }

    // ------------------------------------------------------------------------
    // Owner can transfer out any accidentally sent ERC20 tokens
    // ------------------------------------------------------------------------

    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns(bool success) {
        return NormalTransfer(tokenAddress).transfer(owner, tokens);
    }

}
