//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract CrowdFund {

    //contract that collects ETH from numerous addresses using a payable stake()
    // function and keeps track of balances. After some deadline if it has at least 
    // some threshold of ETH, it sends it to an ExampleExternalContract and triggers 
    //the complete() action sending the full balance. If not enough ETH is collected, allow users to withdraw().

    uint256 public thresholdETH;

    uint256 public deadline;

    mapping(address => uint256) public moneyCollected;

    address public ownerContract;
    
    constructor (
        uint256 _thresholdETH, 
        uint256 _deadline,
        address _ownerContract)
    {
        thresholdETH = _thresholdETH;
        deadline = _deadline;
        ownerContract = _ownerContract;
    }

    modifier enoughMoneyCollected () {
        require((address(this).balance >= thresholdETH), "not enough ETH yet");
        _;
    }

    modifier campaignActive() {
        // check here if deadline has passed
        // 1. how do I check current time on chain?
        // 2. will the contract be unavailable for sending funds if the deadline has passed?
        // 3. how will i acheive #2?
        _;
    }

    event depositReceived(address indexed sender, string message);

    event Log(address indexed sender, string message);

    function deposit() public payable {
        // balance is updated automatically
        emit depositReceived(msg.sender, "we have received your deposit");
        moneyCollected[msg.sender] += msg.value;
    }

    function withdraw() public {
        // if deadline has passed this should be triggered
        // check amt of ETH collected and if < threshold, allow each user to withdraw amount they deposited
    }

    function transfer() public {
        // in case the deadline has passed or enough money has been collected, send ETH to external contract
        // how do I transfer funds to another contract?
        // push vs pull pattern?
        // does this get trigered automatically when conditions are fulfilled?
    }

    receive() external payable {
        emit Log(msg.sender, "receive()");
    }
}