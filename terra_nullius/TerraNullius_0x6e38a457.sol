// Source for Terra Nullius at 0x6e38A457C722C6011B2dfa06d49240e797844d66 (block 49,880, 7 Aug 2015 20:48 UTC).
// Etherscan has verified source for this contract (Solidity 0.1.1, optimizer off), but its text could not
// be retrieved for this repository, so this file was written to match the deployed code. Compiled with
// soljson v0.1.1+commit.6ff4cd6 with the optimizer off, it reproduces the deployed code and the deployment
// transaction's input byte for byte. Its formatting may differ from Etherscan's copy.

contract TerraNullius {
  struct Claim { address claimant; string message; uint block_number; }
  Claim[] public claims;

  function claim(string message) {
    uint index = claims.length;
    claims.length++;
    claims[index] = Claim(msg.sender, message, block.number);
  }

  function number_of_claims() returns(uint result) {
    return claims.length;
  }
}
