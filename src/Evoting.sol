// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract Evoting {
    address private owner;

    constructor() {
        owner = msg.sender;
    }

    bool canVote;
    uint256 currentVoteId; // help if we have multiple vote, then we can filter data history by the voteId
    mapping(address => bool) public userHasVoted;
    uint256 public totalVote;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not an owner");
        _;
    }

    modifier onlyUser() {
        require(msg.sender != owner, "Owner can't make vote!!");
        _;
    }

    event VoteCast(address indexed voter, uint256 indexed voteId, uint256 timestamp);

    function updateVoteStatus(bool value) external onlyOwner {
        if (value) {
            currentVoteId += 1;
        }

        canVote = value;
    }

    function vote() external onlyUser {
        require(canVote, "Vote closed!!");
        require(!userHasVoted[msg.sender], "You've been voted!!");
        userHasVoted[msg.sender] = true;
        totalVote += 1;

        emit VoteCast(msg.sender, currentVoteId, block.timestamp);
    }
}
