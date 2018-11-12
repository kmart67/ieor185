pragma ^0.4.17;

//mapping guns to owners
contract Records {

    struct User {
        bool verified; //verified user iff went through background checks
        string name;
    }

    struct Gun {
        string name;
        uint256 serial;
        string manufacturer;
        address owner;
        bool initialized;
    }

    //Mapping to store guns.
    mapping(uint256 => Gun) records;

    event acceptedInitialization(address owner, string name, uint256 serial, string manufacturer);
    event rejectInitialization(address owner, uint256 serial, string message);
    event acceptedTransfer(address owner, address to, uint256 gunSerial);
    event rejectTransfer(address owner, address to, uint256 gunSerial, string message);

    //Adds gun to our records.
    function addGun(string name, uint256 serial, string manufacturer) {
        if (records[serial].initialized) {
            rejectInitialization(msg.sender, serial, "This gun is already instantiated.");
        }

        records[serial] = Gun(name, serial, manufacturer, msg.sender, true);
        acceptedInitialization(msg.sender, name, serial, manufacturer);
    }

    //msg.value will be gun ID
    function isOwnerOf(address owner, uint256 serial) constant public returns (bool) {
        return (records[serial].owner == owner);
    }

    //Transfers ownership of a gun.
    function transferOwner(uint256 gunSerial, address newOwner) {
        if (!records[gunSerial].initialized) {
            rejectTransfer(msg.sender, newOwner, gunSerial, "No gun with this serial number exists.");
        }

        if (records[gunSerial].owner != msg.sender) {
            rejectTransfer(msg.sender, newOwner, gunSerial, "Sender does not own this gun.");
        } else {
            records[gunSerial].owner = newOwner;
            acceptedTransfer(msg.sender, newOwner, gunSerial);
        }
    }
}