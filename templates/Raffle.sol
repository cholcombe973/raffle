pragma solidity ^0.4.0;

/*
1. Jinja2 template to securely generate the random numbers using a hardware device.
2. Use truffle that generates an app with a UI already built.
3. Store the winners in a database that we control.  WinnerFound log event.
   Our service picks that up and reports it in a database.

Specification
As a user I can draw a raffle ticket.
As a user I can send a raffle ticket to another user.
As the raffle system I can select a winning raffle ticket and trace the winning ticket holder.

Requirements:
The system should have a minimum UI.
*/
contract Raffle{
  //Public
  //Total pop of the raffle
  uint public balance;
  //Everyone who holds a ticket
  mapping(address => Ticket[]) public ticketHolders;

  //Private
  //This raffle is over and paid out to a winner
  bool hadPayout;
  //Approx $2
  uint constant ticketPrice = 250 finney;
  Ticket winningNumber;

  event LogTicketPurchased(address publicAddress);

  // First 5 chosen from a group of 69 numbers.
  // 6th chosen from a set of 26 numbers.
  struct Ticket{
    //Hardware random number generator
    uint8 first;
    uint8 second;
    uint8 third;
    uint8 fourth;
    uint8 fifth;
    uint8 sixth;
  }

  function Raffle(){
    //Constructor
    winningNumber = Ticket({
      first:{{first}},
      second:{{second}},
      third:{{third}},
      fourth:{{fourth}},
      fifth:{{fifth}},
      sixth:{{sixth}}
    });
  }

  function transferTicketToUser(address user){

  }

  function checkForWinner(){
    //Check for hadPayout
    //count down and check for winner.
    //if winner, move winnings and exit.
    if(!hadPayout){

    }
  }

  //Buying a ticket costs approx $2 of ether
  function buyTicket(uint8 first,
                     uint8 second,
                     uint8 third,
                     uint8 fourth,
                     uint8 fifth,
                     uint8 sixth) returns (bool purchased){
    //Generate a ticket for the user
    //Check for hadPayout
    if (! hadPayout){
      if (first < 69 && second < 69 && third < 69 && fourth < 69 && fifth < 69 && sixth < 26){
        //Special variable
        //How much someone sent me
        if (msg.value < ticketPrice){
          return false;
        }else{
          balance += msg.value;
          ticketHolders[msg.sender].push(Ticket(
            {
              first: first,
              second: second,
              third: third,
              fourth: fourth,
              fifth: fifth,
              sixth: sixth,
            }
          ));
          //Fire event
          LogTicketPurchased(msg.sender);
        }
      }
    }
  }
}
