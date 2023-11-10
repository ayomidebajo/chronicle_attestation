// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Chronicle {
    // Structure to hold car history details:
    struct CarHistory {
        string[] ownershipChanges;
        uint engineLoad;
        uint distanceWithMilage;
        uint throttlePosition;
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
        newCarHistory.engineLoad = 30;
        newCarHistory.distanceWithMilage = 20;
        newCarHistory.throttlePosition = 0;

        emit CarRegistered(vin, initialOwner);
    }

    // Function to add or update car history
    function updateCarHistory(
        string memory vin,
        uint newEngineLoad,
        uint newDistanceWithMilage,
        uint newThrottlePosition
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

    enum Condition {
        Good,
        Medium,
        Bad
    }

    function evaluateCar(string memory vin) public view returns (Condition) {
        CarHistory memory history = carHistories[vin];

        Condition engineLoadScore = evaluateEngineLoad(history.engineLoad);
        Condition distanceScore = evaluateDistance(history.distanceWithMilage);
        Condition throttleScore = evaluateThrottle(history.throttlePosition);

        return
            calculateGlobalScore(engineLoadScore, distanceScore, throttleScore);
    }

    // function evaluateEngineLoad(
    //     uint load
    // ) internal pure returns (string memory) {
    //     if (load <= 40) return "Good";
    //     if (load <= 70) return "Medium";
    //     return "Bad";
    // }

    // function evaluateDistance(
    //     uint distance
    // ) internal pure returns (string memory) {
    //     if (distance <= 50000) return "Good";
    //     if (distance <= 150000) return "Medium";
    //     return "Bad";
    // }

    // function evaluateThrottle(
    //     uint position
    // ) internal pure returns (string memory) {
    //     if (position <= 40) return "Good";
    //     if (position <= 70) return "Medium";
    //     return "Bad";
    // }

    function evaluateEngineLoad(uint load) internal pure returns (Condition) {
        if (load <= 40) return Condition.Good;
        if (load <= 70) return Condition.Medium;
        return Condition.Bad;
    }

    function evaluateDistance(uint distance) internal pure returns (Condition) {
        if (distance <= 50000) return Condition.Good;
        if (distance <= 150000) return Condition.Medium;
        return Condition.Bad;
    }

    function evaluateThrottle(uint position) internal pure returns (Condition) {
        if (position <= 40) return Condition.Good;
        if (position <= 70) return Condition.Medium;
        return Condition.Bad;
    }

    // function calculateGlobalScore(
    //     Condition engineLoad,
    //     Condition distance,
    //     Condition throttle
    // ) internal pure returns (string memory) {
    //     uint score = 0;
    //     if (engineLoad == Condition.Good) {
    //         score += 1;
    //     }
    //     if (distance == Condition.Good) {
    //         score += 1;
    //     }
    //     if (throttle == Condition.Good) {
    //         score += 1;
    //     }

    //     if (score >= 2) return Condition.Good;
    //     if (score == 1) return Condition.Medium;
    //     return Condition.Bad;
    // }

    function calculateGlobalScore(
        Condition engineLoad,
        Condition distance,
        Condition throttle
    ) internal pure returns (Condition) {
        uint score = 0;
        if (engineLoad == Condition.Good) score += 1;
        if (distance == Condition.Good) score += 1;
        if (throttle == Condition.Good) score += 1;

        if (score >= 2) return Condition.Good;
        if (score == 1) return Condition.Medium;
        return Condition.Bad;
    }

    modifier onlyCarOwner(string memory vin) {
        require(carOwners[vin] == msg.sender, "Is not the owner");
        _;
    }
}
