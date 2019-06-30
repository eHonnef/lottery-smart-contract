pragma solidity 0.5.11;

import "./Owner.sol";

contract Lottery is Owner {
  uint internal nTickets;
  uint internal ticket_price;
  uint internal prize;
  uint internal counter;
  uint internal aTickets;

  mapping (uint => address) internal players;
  mapping (address => bool) internal addresses;

  event winner(uint indexed counter, address winner, string message);

  function status() public view returns(uint, uint, uint, uint) {
    return (nTickets, aTickets, ticket_price, prize);
  }

  constructor(uint tickets, uint price) public payable onlyOwner {
    if (tickets <= 1 || price == 0 || msg.value < price) {
      revert();
    }

    nTickets = tickets;
    ticket_price = price;
    aTickets = nTickets - 1;
    players[++counter] = owner;
    prize += msg.value;
    addresses[owner] = true;
  }

  function play() public payable {
    if (addresses[msg.sender] || msg.value < ticket_price || aTickets == 0) {
      return;
    }

    aTickets = nTickets - 1;
    players[++counter] = msg.sender;
    prize += msg.value;
    addresses[msg.sender] = true;
    if (aTickets == 0) {
      raffle();
    }
  }

  function raffle() internal {
    uint index = uint(blockhash(block.number - 1)) % nTickets;
    address winnerAddr = players[index];
    emit winner(index, winnerAddr, "The raffle found its winner!!");
    winnerAddr.transfer(prize);
  }
}
