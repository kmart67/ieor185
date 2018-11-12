pragma ^0.4.17;

//mapping guns to owners
contract Records {
    mapping(uint256 => address) documentations;

    //msg.value will be gun ID
    function checkOwner() constant public returns (address owner) {
        return documentations[msg.value];
    }

    function setOwner() public payable {
        documentations[msg.value] = msg.sender;
    }

    function transferOwner(uint256 gunID, address newOwner) public returns (bool success) {
        if (documentations[gunID] != msg.sender) {
            return false;
        } else {
            documentations[gunID] = newOwner;
        }
    }
}