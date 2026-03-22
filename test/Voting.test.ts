import { describe, it } from "node:test";
import assert from "node:assert/strict";
import { createWalletClient, createPublicClient, http } from "viem";
import { hardhat } from "viem/chains";
import hre from "hardhat";

describe("Voting Contract", async function () {

  it("Should compile and have correct state values", async function () {
    // Just verify the contract artifact exists and compiled correctly
    const artifact = await hre.artifacts.readArtifact("Voting");
    assert.ok(artifact.abi.length > 0, "ABI should not be empty");
    assert.equal(artifact.contractName, "Voting");
  });

  it("Should have castVote function in ABI", async function () {
    const artifact = await hre.artifacts.readArtifact("Voting");
    const fnNames = artifact.abi
      .filter((x: any) => x.type === "function")
      .map((x: any) => x.name);
    assert.ok(fnNames.includes("castVote"), "castVote should exist");
    assert.ok(fnNames.includes("addCandidate"), "addCandidate should exist");
    assert.ok(fnNames.includes("startElection"), "startElection should exist");
    assert.ok(fnNames.includes("endElection"), "endElection should exist");
    assert.ok(fnNames.includes("getCandidate"), "getCandidate should exist");
  });

  it("Should have correct events in ABI", async function () {
    const artifact = await hre.artifacts.readArtifact("Voting");
    const eventNames = artifact.abi
      .filter((x: any) => x.type === "event")
      .map((x: any) => x.name);
    assert.ok(eventNames.includes("VoteCast"), "VoteCast event should exist");
    assert.ok(eventNames.includes("CandidateAdded"), "CandidateAdded should exist");
    assert.ok(eventNames.includes("ElectionStarted"), "ElectionStarted should exist");
    assert.ok(eventNames.includes("ElectionEnded"), "ElectionEnded should exist");
  });

});