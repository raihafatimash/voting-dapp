// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Voting {

    // ─── State Variables ───────────────────────────────────
    address public owner;

    enum ElectionState { PENDING, ACTIVE, CLOSED }
    ElectionState public state;

    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    mapping(uint => Candidate) public candidates;
    mapping(address => bool) public hasVoted;
    uint public candidateCount;

    // ─── Events ────────────────────────────────────────────
    event CandidateAdded(uint id, string name);
    event ElectionStarted();
    event ElectionEnded();
    event VoteCast(address voter, uint candidateId);

    // ─── Constructor ───────────────────────────────────────
    constructor() {
        owner = msg.sender;
        state = ElectionState.PENDING;
    }

    // ─── Modifier ──────────────────────────────────────────
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    // ─── Functions ─────────────────────────────────────────

    function addCandidate(string memory _name) public onlyOwner {
        require(state == ElectionState.PENDING, "Cannot add during election");
        candidateCount++;
        candidates[candidateCount] = Candidate(candidateCount, _name, 0);
        emit CandidateAdded(candidateCount, _name);
    }

    function startElection() public onlyOwner {
        require(state == ElectionState.PENDING, "Already started");
        require(candidateCount > 0, "No candidates added");
        state = ElectionState.ACTIVE;
        emit ElectionStarted();
    }

    function castVote(uint _candidateId) public {
        require(state == ElectionState.ACTIVE, "Election not active");
        require(!hasVoted[msg.sender], "Already voted");
        require(_candidateId > 0 && _candidateId <= candidateCount, "Invalid candidate");
        hasVoted[msg.sender] = true;
        candidates[_candidateId].voteCount++;
        emit VoteCast(msg.sender, _candidateId);
    }

    function endElection() public onlyOwner {
        require(state == ElectionState.ACTIVE, "Election not active");
        state = ElectionState.CLOSED;
        emit ElectionEnded();
    }

    function getCandidate(uint _id) public view returns (string memory, uint) {
        require(_id > 0 && _id <= candidateCount, "Invalid candidate");
        Candidate memory c = candidates[_id];
        return (c.name, c.voteCount);
    }

    function getState() public view returns (string memory) {
        if (state == ElectionState.PENDING) return "PENDING";
        if (state == ElectionState.ACTIVE) return "ACTIVE";
        return "CLOSED";
    }
}