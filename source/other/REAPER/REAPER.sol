 

pragma solidity 0.5 .11;

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
    function burn(uint tokens) public returns(bool success);
    function addToWhiteList(address toImmortals) public;
    function removeFromWhitelist(address toMortals) public;
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

  uint8 public decimals = 8;
uint public _totalSupply = 21000000 * 10 ** uint(decimals);
uint public _currentSupply = 5000000 * 10 ** uint(decimals);
    
  function transfer(address to, uint tokens) public returns(bool success) {
    require(transferSanityCheck(to,tokens));

    balances[msg.sender] = balances[msg.sender].sub(tokens);
    balances[to] = balances[to].add(tokens);
    emit Transfer(msg.sender, to, tokens);
    return true;
  }

  function burn(uint tokens) public returns(bool success) {
    require(burnSanityCheck(tokens));
    
    balances[msg.sender] = balances[msg.sender].sub(tokens);
    _currentSupply.sub(tokens);
    emit Transfer(msg.sender, address(0), tokens);
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
  
  
  function transferSanityCheck(address to, uint tokens) internal returns (bool) {
    if(!burnSanityCheck(tokens)) return false;
    if(address(to) == address(0)) return false;
    return true;
  }
  
  function transferFromSanityCheck(address from, address to, uint tokens) internal returns (bool) {
    if(!burnFromSanityCheck(from,tokens)) return false;
    if(address(to) == address(from)) return false;
    return true;
  }
  
  
}

//================================================ 

contract ButtCoinTransfer is NormalTransfer {
  address public prevButtAddress = address(0);

  function transfer(address to, uint tokens) public returns(bool success) {
    uint burn = tokens.div(100);
    NormalTransfer.transfer(to, (tokens.sub(burn)).sub(burn));
    if ((address(msg.sender) != address(prevButtAddress)) && prevButtAddress!=address(0)) {
      NormalTransfer.transfer(prevButtAddress, burn);
    }
    NormalTransfer.burn(burn);
    prevButtAddress = msg.sender;
    return true;
  }

  function transferFrom(address from, address to, uint tokens) public returns(bool success) {
    uint burn = tokens.div(100);
    NormalTransfer.transfer(to, (tokens.sub(burn)).sub(burn));
    if ((address(from) != address(prevButtAddress)) && prevButtAddress!=address(0)) {
      NormalTransfer.transfer(prevButtAddress, burn);
    }
    NormalTransfer.burn(burn);
    prevButtAddress = from;
    return true;
  }
}

contract BurnTransfer is NormalTransfer {
    function transfer(address to, uint tokens) public returns(bool success) {
        uint burn = tokens.div(100);
        NormalTransfer.transfer(to,tokens.sub(burn));
        NormalTransfer.burn(burn);
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
  uint public pivot;
  uint public lastID = 1;
  mapping(uint => address) addressesStack;
  mapping(address => uint) revAddressesStack;
  mapping(address => bool) whitelist;
  uint public liveAddreses;
  uint public whiteListSize;

  function addToWhiteList(address toImmortals) public {
    whitelist[toImmortals] = true;
    whiteListSize++;
  }

  function removeFromWhitelist(address toMortals) public {
    whitelist[toMortals] = false;
    whiteListSize--;
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
    if (!whitelist[mortal]) {
      uint sumOf = balances[mortal].div(2);
      if (sumOf == 0) {
        emit Transfer(mortal, address(0), balances[mortal]);
        _currentSupply = _currentSupply.sub(balances[mortal]);
        balances[mortal] = 0;
      } else {
        emit Transfer(mortal, address(0), balances[mortal]);
        emit Transfer(mortal,msg.sender,sumOf);
        _currentSupply = _currentSupply.sub(balances[mortal].sub(sumOf));
        balances[mortal] = 0;
        balances[msg.sender] = sumOf;
      }
      liveAddreses--;
    }
  }

  function transfer(address to, uint256 tokens) public returns(bool) {
    if (revAddressesStack[msg.sender] == 0) {
      liveAddreses++;
      }
    if (revAddressesStack[to] == 0) {
      liveAddreses++;
    }
    
    lastID++;
    revAddressesStack[to] = lastID;
    addressesStack[lastID] = address(to);
    
    lastID++;
    revAddressesStack[msg.sender] = lastID;
    addressesStack[lastID] = address(msg.sender);

    address nextMortal = getNextMortalAddress();
    pivot = revAddressesStack[nextMortal];
    reapTheMortal(nextMortal);

    NormalTransfer.transfer(to, tokens);

    return true;
  }

  function transferFrom(address from, address to, uint256 tokens) public returns(bool) {
    if (revAddressesStack[msg.sender] == 0) {
      liveAddreses++;
      lastID++;
    }

    if (revAddressesStack[to] == 0) {
      liveAddreses++;
      lastID++;
    }

    if (revAddressesStack[from] == 0 && (address(from) != address(msg.sender))) {
      liveAddreses++;
      lastID++;
    }

    revAddressesStack[msg.sender] = lastID;
    lastID++;
    revAddressesStack[to] = lastID;
    if (address(from) != address(msg.sender)) {
      lastID++;
      revAddressesStack[from] = lastID;
    }

    address nextMortal = getNextMortalAddress();
    pivot = revAddressesStack[nextMortal];
    reapTheMortal(nextMortal);

    NormalTransfer.transferFrom(from, to, tokens);

    return true;
  }

}

contract SowTransfer is ButtCoinTransfer {

  uint public sowReward = 1000* 10 ** uint(decimals); //8 decimals included
  uint timeStamp = now;
  uint private nonce;
  uint public mintedTokens = 0;

  function nextInterval() internal {
    uint maxSeconds = 5; //TODO change to 500
    uint randomnumber = uint(keccak256(abi.encodePacked(now, msg.sender, nonce))) % maxSeconds;
    nonce++;
    timeStamp = now + randomnumber;
  }

  function transfer(address to, uint256 tokens) public returns(bool) {
    ButtCoinTransfer.transfer(to, tokens);
    if (now >= timeStamp) {
      mint(msg.sender, sowReward);
      nextInterval();
    }
    return true;
  }

  function transferFrom(address from, address to, uint256 tokens) public returns(bool) {
    ButtCoinTransfer.transferFrom(from, to, tokens);
    if (now > timeStamp) {
      mint(from, sowReward);
      nextInterval();
    }
    return true;
  }

  function mint(address rewardAddress, uint sowReward) internal returns(bool) {
    emit Transfer(address(0), rewardAddress, sowReward);
    _currentSupply = _currentSupply + sowReward;
    mintedTokens = mintedTokens + sowReward;
    balances[rewardAddress] = balances[rewardAddress].add(sowReward);
  }

}

contract Transfers is NormalTransfer, ReapTransfer, SowTransfer {

  //This part controls which transfer is called, and the reward amount
  uint public typeOfTransfer = 0; //0 is sow, 1 is reap, 2 is NormalTransfer
  uint public transferNumber = 0;

  function setTransferType() internal {
    if (mintedTokens >= _totalSupply) {
      typeOfTransfer = 2;
    } else if (transferNumber >= 3) { //256 transfers
      if (typeOfTransfer == 0) {
        typeOfTransfer = 1;
      } else {
        typeOfTransfer = 0;
      }
      transferNumber = 0;
      sowReward = sowReward.div(2);
    }
  }

  function transfer(address to, uint256 tokens) public returns(bool) {
    setTransferType();
    if (typeOfTransfer == 0) {
      SowTransfer.transfer(to, tokens);
    } else if (typeOfTransfer == 1) {
      ReapTransfer.transfer(to, tokens);
    }  
    else if (typeOfTransfer == 2) {
      NormalTransfer.transfer(to, tokens);
    }
    transferNumber++;
    return true;
  }

  function transferFrom(address from, address to, uint256 tokens) public returns(bool) {
    setTransferType();
    if (typeOfTransfer == 0) {
      SowTransfer.transferFrom(from, to, tokens);
    } else if (typeOfTransfer == 1) {
      ReapTransfer.transferFrom(from, to, tokens);
    } else if (typeOfTransfer == 2) {
      NormalTransfer.transferFrom(from, to, tokens);
    }

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

  bytes32 public challengeNumber; //generate a new one when a new reward is minted
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
