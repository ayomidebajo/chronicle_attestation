// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Chronicle {
    // Structure to hold car history details:
    struct CarHistory {
        string[] ownershipChanges;
        string engineLoad;
        string distanceWithMilage;
        string throttlePosition;
    }

    // Contract's owner (for simple access control)
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // Mapping from VIN to its history
    mapping(string => CarHistory) private carHistories;

    //check if the caller of the update functions is the real owner: string -> VIN, address -> owner address
    mapping(string => address) private carOwners;

    // events:
    event CarHistoryUpdated(string vin);
    event OwnershipChanged(string vin, string newOwner);
    event CarRegistered(string vin, address initialOwner);

    //initial registration for a new car:
    function registerCar(string memory vin, address initialOwner) public {
        require(carOwners[vin] == address(0), "Car already registered");
        carOwners[vin] = initialOwner;

        // Initialize the CarHistory struct for the new car
        CarHistory storage newCarHistory = carHistories[vin];
        newCarHistory.engineLoad = "30";
        newCarHistory.distanceWithMilage = "10";
        newCarHistory.throttlePosition = "0";

        emit CarRegistered(vin, initialOwner);
    }

    // Function to add or update car history
    function updateCarHistory(
        string memory vin,
        string memory newEngineLoad,
        string memory newDistanceWithMilage,
        string memory newThrottlePosition
    ) public onlyCarOwner(vin) {
        CarHistory storage history = carHistories[vin];

        history.engineLoad = newEngineLoad;
        history.distanceWithMilage = newDistanceWithMilage;
        history.throttlePosition = newThrottlePosition;

        emit CarHistoryUpdated(vin);
    }

    function transferOwnership(
        string memory vin,
        address newOwner
    ) public onlyCarOwner(vin) {
        require(
            newOwner != address(0),
            "New owner cannot be non-existant address"
        );
        require(carOwners[vin] != newOwner, "New owner must be different");

        carOwners[vin] = newOwner;

        // Update the ownership history in CarHistory
        CarHistory storage history = carHistories[vin];
        history.ownershipChanges.push(toString(newOwner));

        emit OwnershipChanged(vin, toString(newOwner));
    }

    function toString(address _addr) internal pure returns (string memory) {
        bytes32 value = bytes32(uint256(uint160(_addr)));
        bytes memory alphabet = "0123456789abcdef";
        bytes memory str = new bytes(42);

        str[0] = "0";
        str[1] = "x";
        for (uint i = 0; i < 20; i++) {
            str[2 + i * 2] = alphabet[uint8(value[i + 12] >> 4)];
            str[3 + i * 2] = alphabet[uint8(value[i + 12] & 0x0f)];
        }
        return string(str);
    }

    // Function to retrieve car history
    function getCarHistory(
        string memory vin
    ) public view returns (CarHistory memory) {
        return carHistories[vin];
    }

    function evaluateCar(
        string memory vin
    ) public view returns (string memory) {
        CarHistory memory history = carHistories[vin];

        string memory engineLoadScore = evaluateEngineLoad(history.engineLoad);
        string memory distanceScore = evaluateDistance(
            history.distanceWithMilage
        );
        string memory throttleScore = evaluateThrottle(
            history.throttlePosition
        );

        // Calculate global score
        return
            calculateGlobalScore(engineLoadScore, distanceScore, throttleScore);
    }

    function evaluateEngineLoad(
        string memory load
    ) internal pure returns (string memory) {
        uint loadValue = parseInt(load);
        if (loadValue <= 40) return "Good";
        if (loadValue <= 70) return "Medium";
        return "Bad";
    }

    function evaluateDistance(
        string memory distance
    ) internal pure returns (string memory) {
        uint distanceValue = parseInt(distance);
        if (distanceValue <= 50000) return "Good";
        if (distanceValue <= 150000) return "Medium";
        return "Bad";
    }

    function evaluateThrottle(
        string memory position
    ) internal pure returns (string memory) {
        uint positionValue = parseInt(position);
        if (positionValue <= 40) return "Good";
        if (positionValue <= 70) return "Medium";
        return "Bad";
    }

    function calculateGlobalScore(
        string memory engineLoad,
        string memory distance,
        string memory throttle
    ) internal pure returns (string memory) {
        uint score = 0;
        if (keccak256(bytes(engineLoad)) == keccak256(bytes("Good")))
            score += 1;
        if (keccak256(bytes(distance)) == keccak256(bytes("Good"))) score += 1;
        if (keccak256(bytes(throttle)) == keccak256(bytes("Good"))) score += 1;

        if (score >= 2) return "Good";
        if (score == 1) return "Medium";
        return "Bad";
    }

    function parseInt(string memory s) internal pure returns (uint) {
        bytes memory b = bytes(s);
        uint result = 0;
        uint i;
        for (i = 0; i < b.length; i++) {
            uint c = uint(uint8(b[i]));

            if (c >= 48 && c <= 57) {
                result = result * 10 + (c - 48);
            } else {
                revert("String contains non-numeric characters.");
            }
        }
        return result;
    }

    // Modifier for access control (this is a simple example)
    modifier onlyCarOwner(string memory vin) {
        // You can replace this with your access control logic
        require(carOwners[vin] == msg.sender, "Is not the owner");
        _;
    }
}
