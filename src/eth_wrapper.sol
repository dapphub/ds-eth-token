pragma solidity ^0.4.10;

import 'ds-token/base.sol';
import 'ds-exec/exec.sol';

contract DSEthTokenEvents {
    event Deposit(address indexed who, uint amount);
    event Withdrawal(address indexed who, uint amount);
}

contract DSEthToken is DSTokenBase(0)
                     , DSExec
                     , DSEthTokenEvents
{
    string public constant name     = "Wrapper ETH";
    string public constant symbol   = "W-ETH";
    uint   public constant decimals = 18;

    function totalSupply() constant returns (uint supply) {
        return this.balance;
    }
    function withdraw(uint amount) {
        if (!tryWithdraw(amount)) {
            throw;
        }
    }
    function tryWithdraw(uint amount) returns (bool ok) {
        _balances[msg.sender] = sub(_balances[msg.sender], amount);
        if (tryExec(msg.sender, amount)) {
            Withdrawal(msg.sender, amount);
            return true;
        } else {
            _balances[msg.sender] = add(_balances[msg.sender], amount);
            return false;
        }
    }
    function deposit() payable {
        _balances[msg.sender] += msg.value;
        Deposit(msg.sender, msg.value);
    }

    function() payable {
        deposit();
    }
}
