//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.5.0;

contract TronDice {
    struct Bet {
        address user;
        uint block;
        uint cap;
        uint amount; 
    }

    uint public constant FEE_NUMERATOR = 1;
    uint public constant FEE_DENOMINATOR = 100;
    uint public constant MAXIMUM_CAP = 100000;
    uint public constant MAXIMUM_BET_SIZE = 1e18;

    address payable owner;
    //address owner;
    uint public counter = 0;
    mapping(uint => Bet) public bets;

    event BetPlaced(uint id, address user, uint cap, uint amount);
    event Roll(uint id, uint rolled);

    function Dice () public {
        owner = msg.sender;
    }

    function wager (uint cap) public payable {
        require(cap <= MAXIMUM_CAP);
        require(msg.value <= MAXIMUM_BET_SIZE);

        counter++;
        bets[counter] = Bet(msg.sender, block.number + 3, cap, msg.value);
        emit BetPlaced(counter, msg.sender, cap, msg.value);
        //BetPlaced(counter, msg.sender, cap, msg.value);
    }

    function roll(uint id) public {
        Bet storage bet = bets[id];
        require(msg.sender == bet.user);
        require(block.number >= bet.block);
        require(block.number <= bet.block + 255);

        bytes32 random = keccak256(abi.encodePacked(blockhash(bet.block), id));
        //bytes32 random = keccak256(block.blockhash(bet.block), id);
        uint rolled = uint(random) % MAXIMUM_CAP;
        if (rolled < bet.cap) {
            uint payout = bet.amount * MAXIMUM_CAP / bet.cap;
            uint fee = payout * FEE_NUMERATOR / FEE_DENOMINATOR;
            payout -= fee;
            msg.sender.transfer(payout);
        }

        emit Roll(id, rolled);
        //Roll(id, rolled);
        delete bets[id];
    }

    function fund () payable public {}

    //function kill () public {
    //    require(msg.sender == owner);
    //    selfdestruct(owner);
    //}
}
