pragma solidity ^0.8.9;

contract Lottery {
    address public manager;
    address payable[] public players;

    constructor() {
        manager = msg.sender ;
    }

    function enter() public payable {
        require(msg.value > 0.01 ether) ;
        players.push(payable(msg.sender)) ;
    }

    function random() public view returns(uint) {
       return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,players))) ;
    }

    function pickWinner() public restricted {
        uint randomNum = random() % players.length ;
        players[randomNum].transfer(address(this).balance) ;
        players= new address payable[](0) ;
    }

    modifier restricted() {
        require(msg.sender== manager) ;
        _;
    }
    function getPlayers() public view returns(address payable[] memory) {
        return players;
    }

    function getBalance() public view returns(uint) {
         return address(this).balance;
    }
}