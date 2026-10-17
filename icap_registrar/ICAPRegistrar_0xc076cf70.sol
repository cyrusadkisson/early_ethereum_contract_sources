// Source of the first ICAP registrar deployment at 0xc076CF70C54c698D4442Cde1561452564FA339A5
// (block 50,500, 7 Aug 2015). Never used.
// This is ethereum/dapp-bin registrar/ICAPRegistrar.sol at commit e9f5df9 (6 Aug 2015) without
// its addr() and owner() lookup functions, and with setAddr() placed second. Compiled with
// soljson v0.1.1+commit.6ff4cd6, optimizer on, it reproduces the deployed bytecode exactly;
// see README.md.

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
	function setAddr(bytes32 _name, address _a) onlyrecordowner(_name) {
		m_record[_name].addr = _a;
		Changed(_name);
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


    mapping (bytes32 => Record) m_record;
    uint constant c_fee = 69 ether;
}
