 

pragma solidity 0.5 .11;

// Symbol      :  REAP
// Name        :  The Reaper 
// Total supply:  20,862,499.99998474
// PreMinted: 6,000,000.00000000
// Exchanges allocation: 5,000,000.0000000 from the PreMinted amount
// Developers allocation: 1,000,000.0000000 from the PreMinted amount
// Minimum number of transfers until reaching the total supply: 40962
// Rewards are given within a 10 minutes period to a first account that makes a transfer.
// Rewards are halvened every 512 transfers.
// Initial reward amount is 14500.00000000 tokens.
// Sow period lasts 512 transfers, then Reaping period begins.
// Reap perion lasts 512 transfers, then Sowing period begins with the halvened rewards.
// Reap period means burning the least active accounts and taking 50% of their posessions.
// The minting will continue for at least 0.5 years, or more, depending on a volume of transfers.
// Once the minting is done, all transfers will be normal with a 1% burning fee (without Sowing or Reaping).
// Decimals    :  8
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
  function balanceOf(address tokenOwner) public view returns(uint balance);
}

contract TransfersInterface {
    function transfer(address to, uint tokens) public returns(bool success);
    function transferFrom(address from, address to, uint tokens) public returns(bool success);
    function addToWhiteList(address toImmortals) public;
    function removeFromWhitelist(address toMortals) public;
    function approve(address spender, uint tokens) public returns(bool success);
    function allowance(address tokenOwner, address spender) public view returns(uint remaining);
    function totalSupply() public view returns(uint);

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

  uint8 public decimals = 8;
  uint public _totalSupply = 2086249999998474;
  uint public _currentSupply = 6000000 * 10 ** uint(decimals);
  
  uint public pivot;
  uint public lastID = 1;
  mapping(uint => address) public addressesStack;
  mapping(address => uint) public revAddressesStack;
  mapping(address => bool) public whitelist;
  uint public liveAddreses;
  uint public whiteListSize;
    
  function transfer(address to, uint tokens) public returns(bool success) {
    require(burnSanityCheck(tokens));

    balances[msg.sender] = balances[msg.sender].sub(tokens);
    if(to!=address(0)){
        balances[to] = balances[to].add(tokens);
    }
    else{
        _currentSupply = _currentSupply.sub(tokens);
    }
    emit Transfer(msg.sender, to, tokens);
    return true;
  }

  function approve(address spender, uint tokens) public returns(bool success) {
    allowed[msg.sender][spender] = tokens;
    emit Approval(msg.sender, spender, tokens);
    return true;
  }

  function transferFrom(address from, address to, uint tokens) public returns(bool success) {
    require(transferFromSanityCheck(from,to,tokens));
    balances[from] = balances[from].sub(tokens);
    allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
    if(to!=address(0)){
        balances[to] = balances[to].add(tokens);
    }
    else{
        _currentSupply = _currentSupply.sub(tokens);
    }
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
  
  
  function burnSanityCheck(uint tokens) internal returns (bool){
    if(tokens == 0) return false;
    if(balances[msg.sender] < tokens) return false;
    return true;
  }
  
  function burnFromSanityCheck(address from, uint tokens) internal returns (bool){
    if(tokens == 0) return false;
    if(balances[from] < tokens)  return false;
    if(address(from) == address(0)) return false;
    if(tokens > allowed[from][msg.sender])  return false;
    return true;
  }
  
  function transferFromSanityCheck(address from, address to, uint tokens) internal returns (bool) {
    if(!burnFromSanityCheck(from,tokens)) return false;
    if(address(to) == address(from)) return false;
    return true;
  }
  
  
}

//================================================ 

 
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

contract ReapTransfer is NormalTransfer {

  function addToWhiteList(address toImmortals) public {
    whitelist[toImmortals] = true;
    whiteListSize++;
  }

  function removeFromWhitelist(address toMortals) public {
    whitelist[toMortals] = false;
    whiteListSize--;
  }
  
  function checkWhiteList(address checkAddress) public view returns(bool){
      return whitelist[checkAddress];
  }

  function getNextMortalAddress() public view returns(address) {
    if (liveAddreses.sub(whiteListSize) == 0) return address(0);
    if (pivot == lastID) return address(0);

    uint tmpPivot = pivot;
    for (; tmpPivot <= lastID; tmpPivot++) {
      address pivotAddress = addressesStack[tmpPivot];
      if (pivotAddress != address(0) && !whitelist[pivotAddress]) {
        return addressesStack[tmpPivot];
      }
    }
    return address(0);
  }

  function reapTheMortal(address mortal) internal {
    pivot = revAddressesStack[mortal];
    if (!whitelist[mortal]) {
      uint sumOf = balances[mortal].div(2);
      if (sumOf == 0) {
        _currentSupply = _currentSupply.sub(balances[mortal]);
      } else {
        emit Transfer(mortal,msg.sender,sumOf);
        _currentSupply = _currentSupply.sub(balances[mortal].sub(sumOf));
        balances[msg.sender] = balances[msg.sender].add(sumOf);
      }
      emit Transfer(mortal, address(0), balances[mortal]);
      balances[mortal] = balances[mortal].sub(balances[mortal]);
      revAddressesStack[mortal]=0;
      liveAddreses--;
      pivot++;
      
      if(pivot>=lastID){
          pivot=lastID.sub(1);
      }
      
    }
  }

  function transfer(address to, uint256 tokens) public returns(bool) {
    address nextMortal = getNextMortalAddress();
    if(address(nextMortal)!=address(0) && address(nextMortal)!=address(msg.sender)){
        reapTheMortal(nextMortal);
    }
    NormalTransfer.transfer(to, tokens);

    return true;
  }

  function transferFrom(address from, address to, uint256 tokens) public returns(bool) {
 

    address nextMortal = getNextMortalAddress();
    pivot = revAddressesStack[nextMortal];
    reapTheMortal(nextMortal);

    NormalTransfer.transferFrom(from, to, tokens);

    return true;
  }

}

contract SowTransfer is NormalTransfer {

  uint public sowReward = 14500* 10 ** uint(decimals); //8 decimals included
  uint timeStamp = now;
  uint private nonce;
  uint public mintedTokens = 0;

  function nextInterval() internal {
    uint maxSeconds = 500;
    uint randomnumber = uint(keccak256(abi.encodePacked(now, msg.sender, nonce))) % maxSeconds;
    nonce++;
    timeStamp = now + randomnumber;
  }

  function transfer(address to, uint256 tokens) public returns(bool) {
    NormalTransfer.transfer(to, tokens);
    if (now >= timeStamp) {
      mint(msg.sender, sowReward);
      nextInterval();
    }
    return true;
  }

  function transferFrom(address from, address to, uint256 tokens) public returns(bool) {
    NormalTransfer.transferFrom(from, to, tokens);
    if (now > timeStamp) {
      mint(from, sowReward);
      nextInterval();
    }
    return true;
  }

  function mint(address rewardAddress, uint sowReward) internal returns(bool) {
    emit Transfer(address(0), rewardAddress, sowReward);
    _currentSupply = _currentSupply.add(sowReward);
    mintedTokens = mintedTokens.add(sowReward);
    balances[rewardAddress] = balances[rewardAddress].add(sowReward);
  }

}

contract Transfers is BurnTransfer, ReapTransfer, SowTransfer {

  //This part controls which transfer is called, and the reward amount
  uint public typeOfTransfer = 0; //0 is sow, 1 is reap, 2 is BurnTransfer
  uint private transferNumber = 0;

  function setTransferType() internal {
    if (sowReward <= 2) {
      typeOfTransfer = 2;
    } 
    else if (transferNumber == 512) { //512 transfers
      if (typeOfTransfer == 0) {
        typeOfTransfer = 1;
      } else {
        sowReward = sowReward.div(2);
        typeOfTransfer = 0;
      }
      transferNumber = 0;
    }
  }
  
  function addressStackUpdate(address from, address to) internal{
  if (revAddressesStack[from] == 0) {
      liveAddreses++;
      }
    if (revAddressesStack[to] == 0) { 
      liveAddreses++;
    }
    
    lastID++;
    revAddressesStack[to] = lastID;
    addressesStack[lastID] = address(to);
    
    lastID++;
    revAddressesStack[from] = lastID;
    addressesStack[lastID] = address(from);
  }

  function transfer(address to, uint256 tokens) public returns(bool) {
    addressStackUpdate(msg.sender, to);
    setTransferType();
    if (typeOfTransfer == 0) {
      SowTransfer.transfer(to, tokens);
    } else if (typeOfTransfer == 1) {
      ReapTransfer.transfer(to, tokens);
    }  
    else if (typeOfTransfer == 2) {
      BurnTransfer.transfer(to, tokens);
    }
    transferNumber++;
    return true;
  }

  function transferFrom(address from, address to, uint256 tokens) public returns(bool) {
    addressStackUpdate(from, to);
    setTransferType();
    if (typeOfTransfer == 0) {
      SowTransfer.transferFrom(from, to, tokens);
    } else if (typeOfTransfer == 1) {
      ReapTransfer.transferFrom(from, to, tokens);
    } else if (typeOfTransfer == 2) {
      BurnTransfer.transferFrom(from, to, tokens);
    }
    transferNumber++;
    return true;
  }

}

// ----------------------------------------------------------------------------
// REAPER, MAIN CONTRACT
// ----------------------------------------------------------------------------

contract REAEPER is ERC20Interface, Owned, Transfers {

  using SafeMath
  for uint;

  string public symbol;
  string public name;

  bool locked = false;

 
  // ------------------------------------------------------------------------
  // Constructor
  // ------------------------------------------------------------------------

  constructor() public onlyOwner {
    if (locked) revert();
    symbol = "REAP";
    name = "The Reaper";
    decimals = 8;
    emit Transfer(address(0), msg.sender, _currentSupply);
    mintedTokens = _currentSupply;
    balances[msg.sender] = _currentSupply;
    locked = true;
  }

  function transfer(address to, uint256 tokens) public returns(bool) {
    Transfers.transfer(to, tokens);
    return true;
  }

  function transferFrom(address from, address to, uint256 tokens) public returns(bool) {
    Transfers.transferFrom(from, to, tokens);
    return true;
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
