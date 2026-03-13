//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract CrowdFundContract {

    //contract that collects ETH from numerous addresses using a payable stake()
    // function and keeps track of balances. After some deadline if it has at least 
    // some threshold of ETH, it sends it to an ExampleExternalContract and triggers 
    // the complete() action sending the full balance. 
    // If not enough ETH is collected, allow users to withdraw().

    uint256 public thresholdETH;

    uint256 public deadline;

    mapping(address => uint256) public moneyCollected;

    address public fundRecipientContract;
    
    constructor (
        uint256 _thresholdETH, 
        uint256 _deadline,
        address _fundRecipientContract)
    {
        thresholdETH = _thresholdETH;
        deadline = _deadline;
        fundRecipientContract = _fundRecipientContract;
    }

    // had to convert from modifiers to functions because I needed the inverse for withdraw()

    // modifier enoughMoneyNotCollected() {
    //     require((address(this).balance <= thresholdETH), "we've gotten enough ETH");
    //     _;
    // }

    // modifier campaignActive() {
    //     require(block.timestamp < deadline, "the deadline has passed");
    //     _;
    // }

    function isEnoughETHCollected() public view returns (bool){
        if (address(this).balance <= thresholdETH){
            return true;
        } 
        return false;
    }

    function campaignActive() public view returns (bool){
        if (block.timestamp < deadline) return true;
        return false;
    }

    event depositReceived(address indexed sender, uint256 indexed amount, string message);

    event Log(address indexed sender, string message);

    event CompleteCampaign(address indexed receiver, string message);

    function deposit() public payable {

        require(campaignActive(), "campaign expired");

        require(!isEnoughETHCollected(), "enough money was collected");

        require(msg.value > 0, "not enough");

        moneyCollected[msg.sender] += msg.value;

        emit depositReceived(msg.sender, msg.value, "deposit made");
        
    }

    function withdraw() external{

        require(!campaignActive(), "campaign's still active");

        require(!isEnoughETHCollected(), "enough money was collected");

                // check user's deposit amount
                // wait, what about reentrancy???? how do I check for that
                uint256 amount = moneyCollected[msg.sender];
                require(amount > 0, "no amount deposited");

                // updating balance
                moneyCollected[msg.sender] = 0;

                // send money
                (bool success, ) = payable(msg.sender).call{value: amount}("");
                require(success, "withdrawal failed");
    }

    function transfer() public {
        // in case the deadline has passed or enough money has been collected, send ETH to external contract
        // how do I transfer funds to another contract?
        // does this get trigered automatically when conditions are fulfilled?
        
        require(isEnoughETHCollected(), "not enough ETH collected");

        require(!campaignActive(), "campaign is still active");

        (bool success, ) = payable(fundRecipientContract).call{value: address(this).balance}("");

        require(success, "Completion transfer failed");

        emit CompleteCampaign(fundRecipientContract, "successfully finished campaign");

    }

    receive() external payable {
        emit Log(msg.sender, "receive()");
    }

    // TODO rename the contract and deposit function before submitting to the challenge
}