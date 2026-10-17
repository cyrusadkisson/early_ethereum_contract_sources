// Reconstructed source for the "Documents" contract at 0x5548e21695f8F5E4eDBcd8aBc2de0924c718dAcA
// (block 74,814, 12 Aug 2015 15:20 UTC, deployed by 0x286c2305Af13204F46Da83Dc2Ed5eAB84AB8046f).
// No original source has been found. This was written from the deployed bytecode. Compiled with
// soljson v0.1.1+commit.6ff4cd6, optimizer on, it reproduces the deployed code byte for byte,
// constructor included; see README.md.
// The names of the public functions, mappings and the event are confirmed by their hashes in the
// code. Other names (owner, latest, createHistory, the struct and its fields, parameters and locals)
// are guesses and do not affect the bytecode.
// newDocument returns true even when the hash is already registered (it then changes nothing). The
// redundant assignments in it are what reproduce the deployed code.

contract Documents {
    address owner;
    uint latest;

    struct Document {
        uint blockNumber;
        bytes32 hash;
        address from;
        address to;
    }

    mapping (uint => Document) public history;
    mapping (bytes32 => bool) public usedHashes;
    mapping (bytes32 => address) public documentHashMap;

    event DocumentEvent(uint blockNumber, bytes32 indexed hash, address indexed from, address indexed to);

    function Documents() {
        owner = msg.sender;
    }

    function newDocument(bytes32 hash) returns (bool success) {
        if (documentExists(hash)) {
            success = false;
        } else {
            createHistory(hash, msg.sender, msg.sender);
            usedHashes[hash] = true;
            success = true;
        }
        success = true;
    }

    function createHistory(bytes32 hash, address from, address to) internal {
        ++latest;
        documentHashMap[hash] = to;
        usedHashes[hash] = true;
        history[latest] = Document(block.number, hash, from, to);
        DocumentEvent(block.number, hash, from, to);
    }

    function transferDocument(bytes32 hash, address recipient) returns (bool success) {
        success = false;
        if (documentExists(hash)) {
            if (documentHashMap[hash] == msg.sender) {
                createHistory(hash, msg.sender, recipient);
                success = true;
            }
        }
        return success;
    }

    function documentExists(bytes32 hash) constant returns (bool exists) {
        if (usedHashes[hash]) {
            exists = true;
        } else {
            exists = false;
        }
        return exists;
    }

    function getDocument(uint docId) constant returns (uint blockNumber, bytes32 hash, address from, address to) {
        Document doc = history[docId];
        blockNumber = doc.blockNumber;
        hash = doc.hash;
        from = doc.from;
        to = doc.to;
    }

    function getLatest() constant returns (uint) {
        return latest;
    }

    function empty() {
        uint balance = this.balance;
        owner.send(balance);
    }
}
