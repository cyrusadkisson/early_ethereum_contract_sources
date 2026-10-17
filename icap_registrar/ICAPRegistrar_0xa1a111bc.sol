// Source of the ICAP registrar at 0xa1A111bc074c9cfa781F0C38e63bD51c91b8af00 (block 52,426, 8 Aug 2015),
// the address web3.js hard-coded as its ICAP registry from 8 Aug 2015 (commit 3373b8f).
// This is ethereum/dapp-bin registrar/ICAPRegistrar.sol at commit e9f5df9 (6 Aug 2015), unchanged
// except that transfer() is placed before disown(). Compiled with soljson v0.1.1+commit.6ff4cd6,
// optimizer on, it reproduces the deployed bytecode exactly; see README.md.

//sol ICAP REGISTRAR 
// Simple global registrar with fixed-fee reservations.
// @authors:
//   Gav Wood <g@ethdev.com>

contract ICAPRegistrar {

	struct Record {
		address addr;
		address owner;
	}

	event Changed(bytes32 indexed name);

	modifier onlyrecordowner(bytes32 _name) { if (m_record[_name].owner == msg.sender) _ }

	function reserve(bytes32 _name) {
		if (m_record[_name].owner == 0 && msg.value >= c_fee) {
			m_record[_name].owner = msg.sender;
			Changed(_name);
		}
	}
	function transfer(bytes32 _name, address _newOwner) onlyrecordowner(_name) {
		m_record[_name].owner = _newOwner;
		Changed(_name);
	}

	function disown(bytes32 _name, address _refund) onlyrecordowner(_name) {
		delete m_record[_name];
		_refund.send(c_fee);
		Changed(_name);
	}

	function setAddr(bytes32 _name, address _a) onlyrecordowner(_name) {
		m_record[_name].addr = _a;
		Changed(_name);
	}
	
	function addr(bytes32 _name) constant returns (address) { return m_record[_name].addr; }
	function owner(bytes32 _name) constant returns (address) { return m_record[_name].owner; }

    mapping (bytes32 => Record) m_record;
    uint constant c_fee = 69 ether;
}
