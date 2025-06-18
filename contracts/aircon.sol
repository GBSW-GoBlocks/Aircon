// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract aircon {
    enum Status { off, on }
    enum Mod { ice, hot }
    enum Power { weak, medium, strong }
    enum Option { up, down }
    
    address owner;

    int defaultAirconTemp;
    int public airconTemp;
    uint public airconCost;

    Status public airconStatus = Status.off;
    Mod public airconMod = Mod.ice;
    Power public airconPower = Power.medium;

    event ChangedAirconTemp(int temp, string message);
    event ChangeAirconStatus(Status airconStatus, string message);
    event ChangeAirconMod(Mod airconMod, string message);
    event ChangeAirconPower(Power airconPower, string message);

    constructor(address _owner, uint _airconCost, int _defaultAirconTemp) {
        owner = _owner;
        airconCost = _airconCost;
        defaultAirconTemp = _defaultAirconTemp;
        airconTemp = _defaultAirconTemp;
    }

    modifier onlyOwner {
        require(owner == msg.sender, "This function can use only owner");
        _;
    }

    modifier useAircon {
        require(msg.value >= airconCost, "Not enough ETH");
        _;
    }

    modifier isAirconOn {
        if (airconStatus == Status.on) {
            _;
        }
        else {
            revert("aircan should be on");
        }
    }

    function changeDefaultTemp(int _newDefaultTemp) public onlyOwner {
        defaultAirconTemp = _newDefaultTemp;
    }

    function changeAirconCost(uint _newAirconCost) public onlyOwner {
        airconCost = _newAirconCost;
    }

    function changeAirconStatus(Status _status, string memory _message) public payable useAircon {
        if (Status.on == _status) {
            require(Status.on != airconStatus, "aircon already on");
            airconStatus = Status.on;

            emit ChangeAirconStatus(airconStatus, _message);
        }
        else if (Status.off == _status) {
            require(Status.off != airconStatus, "aircon already off");
            airconStatus = Status.off;
            airconTemp = defaultAirconTemp;

            emit ChangeAirconStatus(airconStatus, _message);
        }
        else {
            revert("Unknown Mod");
        }
    }

    function changeAirconTemp(Option _option, string memory _message) public payable useAircon isAirconOn {
        if (Option.up == _option) {
            airconTemp++;
            emit ChangedAirconTemp(airconTemp, _message);
        }
        else if (Option.down == _option) {
            airconTemp--;
            emit ChangedAirconTemp(airconTemp, _message);
        }
        else {
            revert("Unknown Mod");
        }
    }

    function changeAirconMod(Mod _mod, string memory _message) public payable useAircon isAirconOn {
        if (Mod.ice == _mod)  {
            require(Mod.ice != airconMod, "aircon already ice mod");
            airconMod = Mod.ice;
            emit ChangeAirconMod(airconMod, _message);
        }
        else if (Mod.hot == _mod) {
            require(Mod.hot != airconMod, "aircon already hot mod");
            airconMod = Mod.hot;
            emit ChangeAirconMod(airconMod, _message);
        }
        else {
            revert("Unknown Mod");
        }
    }

    function changePower(Power _power, string memory _message) public payable useAircon isAirconOn {
        if (Power.weak == _power) {
            require(airconPower != Power.weak, "aircon power already weak");
            airconPower = Power.weak;
            emit ChangeAirconPower(airconPower, _message);
        }
        else if (Power.medium == _power) {
            require(airconPower != Power.medium, "aircon power already medium");
            airconPower = Power.medium;
            emit ChangeAirconPower(airconPower, _message);
        }
        else if (Power.strong == _power) {
            require(airconPower != Power.strong, "aircon power already strong");
            airconPower = Power.strong;
            emit ChangeAirconPower(airconPower, _message);
        }
        else {
            revert("Unknown Mod");
        }
    }
}