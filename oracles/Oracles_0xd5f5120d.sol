// Reconstructed source for the "Oracles" contract at 0xd5f5120d1fdfda5ef60fca1f81d709f0432738af
// (block 136,950, 24 Aug 2015 17:35 UTC, deployed by 0x77b97786B0FB73e55d9E92d4B182beFBF346F979).
// No original source has been found. This was written from the deployed bytecode. Compiled with
// soljson v0.1.1+commit.6ff4cd6, optimizer on, it reproduces the deployed code byte for byte,
// constructor included; see README.md.
// Every function name is confirmed by its selector: setWinningOutcome(uint32) and hardSet(uint16)
// were found by testing candidate names against their selectors; the rest are in public signature
// databases. The deployed code never reads or writes storage slot 0, so "uint x" stands in for
// whatever was declared there. Parameter and local names are guesses and do not affect the bytecode.

contract Oracles {
    uint x;
    address public oracle1;
    address public oracle2;
    address public oracle3;
    address public owner;
    uint32 public value1;
    uint32 public value2;
    uint32 public value3;
    uint16 public value;

    function Oracles() {
        oracle1 = msg.sender;
        oracle2 = msg.sender;
        oracle3 = msg.sender;
        owner = msg.sender;
    }

    function changeOwner(uint8 oracle, address newOwner) {
        if (oracle == 1 && msg.sender == oracle1)
            oracle1 = newOwner;
        if (oracle == 2 && msg.sender == oracle2)
            oracle2 = newOwner;
        if (oracle == 3 && msg.sender == oracle3)
            oracle3 = newOwner;
    }

    function setWinningOutcome(uint32 outcome) {
        if (msg.sender == oracle1 && value1 == 0)
            value1 = outcome;
        if (msg.sender == oracle2 && value2 == 0)
            value2 = outcome;
        if (msg.sender == oracle3 && value3 == 0)
            value3 = outcome;
    }

    function hardSet(uint16 _value) {
        if (now > 1446336000)
            value = _value;
    }

    function getWinningOutcome(uint eventIdentifier) returns (uint16 outcome) {
        uint result = 0;
        if (value1 == value2 && value1 != 0)
            result = value1;
        if (value2 == value3 && value2 != 0)
            result = value3;
        if (value1 == value3 && value1 != 0)
            result = value1;
        if (result != outcome) {
            if (result > 20000000)
                return 10001;
            return uint16(result * 10000 / 20000000 + 1);
        }
        return value;
    }
}
