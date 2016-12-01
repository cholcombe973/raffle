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
  //Total pot of the raffle
  uint public balance;

  //Everyone who holds a ticket
  address[] accounts;
  mapping(address => Ticket[]) public ticketHolders;

  //Private
  //This raffle is over and paid out to a winner
  bool hadPayout;
  //Approx $2
  uint constant ticketPrice = 250 finney;
  Ticket winningNumber;

  //Record which addresses purchased a ticket in our database
  event LogTicketPurchased(address publicAddress);
  //Record who won the raffle in our database
  event LogRaffleWinner(address publicAddress);

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
    hadPayout = false;
    winningNumber = Ticket({
      first:3,
      second:63,
      third:59,
      fourth:17,
      fifth:52,
      sixth:15
    });
  }

  //TODO: How can this be implemented?
  function transferTicketToUser(address user){

  }

  function checkForWinner() returns (bool){
    //Check for hadPayout
    //count down and check for winner.
    //if winner, move winnings and exit.
    if(!hadPayout){
      //Loop through all accounts
      for(uint256 addr = 0; addr < accounts.length; addr++){
        //Loop through all tickets that each account holds
        for(uint256 ticket_number = 0; ticket_number < ticketHolders[accounts[addr]].length; ticket_number++){
          if (ticketHolders[accounts[addr]][ticket_number].first == winningNumber.first &&
                     ticketHolders[accounts[addr]][ticket_number].second == winningNumber.second &&
                     ticketHolders[accounts[addr]][ticket_number].third == winningNumber.third &&
                     ticketHolders[accounts[addr]][ticket_number].fourth == winningNumber.fourth &&
                     ticketHolders[accounts[addr]][ticket_number].fifth == winningNumber.fifth &&
                     ticketHolders[accounts[addr]][ticket_number].sixth == winningNumber.sixth){
                       //We have a winner!
                       address winner = accounts[addr];
                       if (winner.send(balance - 25000*tx.gasprice)){
                         //Log our winner
                         LogRaffleWinner(winner);
                         //Balance was transfered.  Delete balance and mark hadPayout as true;
                         delete balance;
                         hadPayout = true;
                         return true;
                       }else{
                         return false;
                       }
           }
        }
      }
      //We looped through everyone and didn't find a winner
      return false;
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
          accounts.push(msg.sender);
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