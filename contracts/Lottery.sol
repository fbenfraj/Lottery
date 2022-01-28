pragma solidity ^0.4.17;

contract Lottery {
    address public manager;
    address[] public players;

    // constructor
    function Lottery() public {
        manager = msg.sender;
    }

    // payable = eth amount can be send along the transaction
    function enter() public payable {
        // error thrown if insuffisant amount
        require(msg.value > .01 ether);
        players.push(msg.sender);
    }

    // pseudo random number generator based on block difficulty, time and the number of players in the lottery
    function random() private view returns (uint256) {
        return uint256(keccak256(block.difficulty, now, players));
    }

    // restricted = modifier function see below
    function pickWinner() public restricted {
        // get the index of the winner (int between 0 and the number of players)
        uint256 index = random() % players.length;
        players[index].transfer(this.balance);
        players = new address[](0);
    }

    // to avoir having to repeat that line everytime we want a manager only function
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    function getPlayers() public view returns (address[]) {
        return players;
    }
}
