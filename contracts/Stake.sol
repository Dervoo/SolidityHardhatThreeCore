// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Stake is ERC20, ERC20Burnable, Pausable, Ownable {

    uint256 public stakedTokens;
    uint256 public interestRate;
    address private erc20token;

    mapping(address => uint256) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isCurrentlyStaking;

    address[] public stakers;

    constructor() ERC20("Tokk", "TOK") Ownable() {
        _mint(msg.sender, 10000 * 10**decimals());
        _mint(address(this), 10000 * 10**decimals());
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function _beforeTokenTransfer(
    address from,
    address to,
    uint256 amount
) internal override(ERC20) whenNotPaused {
    super._beforeTokenTransfer(from, to, amount);
}

    function stake(uint256 amount) public {
        ERC20.transferFrom(msg.sender, address(this), amount);
        stakedTokens += amount;
        stakingBalance[msg.sender] += amount;
        if (!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }
        hasStaked[msg.sender] = true;
        isCurrentlyStaking[msg.sender] = true;
    }

    function withdrawStakedTokens() public {
        uint256 balance = stakingBalance[msg.sender];
        require(balance > 0, "There are no tokens to withdraw");
        stakingBalance[msg.sender] = 0;
        isCurrentlyStaking[msg.sender] = false;
        stakedTokens -= balance;
        this.transfer(msg.sender, balance);
    }

    function setInterestRate(uint256 _value) public onlyOwner {
        require(_value > 0, "There is no point in having 0 rate");
        interestRate = _value;
    }

    // redistribute as autotask through Openzeppelin Defender!
    function handOutAwards() public onlyOwner {
        for (uint256 i = 0; i < stakers.length; i++) {
            address staker = stakers[i];

            uint256 reward = stakingBalance[staker] * interestRate / 100;
            uint256 balance = balanceOf(address(this));
            require(balance >= reward + stakedTokens, "#1");
            stakingBalance[staker] += reward;
            stakedTokens += reward;
        }
    }
}
// Stake nie odejmuje z totalsupply po wypłacie trzeba odejmowac totalsupply przez nwm - balance albo palenie tokenow i ew domintowywac

// funkcje po kolei: normalne flow: increase allowance dla kogos, stake, set interest rate ogolem, hand out rewards i withdraw