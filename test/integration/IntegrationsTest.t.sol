//SPDX--License-Identifier:MIT
pragma solidity ^0.8.18;
import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    FundMe fundMe;
    address USER = makeAddr("Bob");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanFundInteractions() public {
        // 实例化 FundFundMe 合约，用于执行向 FundMe 合约发送资金的操作
        FundFundMe fundFundMe = new FundFundMe();

        // 调用 fundFundMe 函数，向 fundMe 合约发送固定金额的资金
        fundFundMe.fundFundMe(address(fundMe));

        // 实例化 WithdrawFundMe 合约，用于执行从 FundMe 合约提取资金的操作
        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();

        // 调用 withdrawFundMe 函数，从 fundMe 合约中提取所有资金
        withdrawFundMe.withdrawFundMe(address(fundMe));

        // 断言，确保在提取资金之后，FundMe 合约的余额变为 0
        assert(address(fundMe).balance == 0);

        // vm.prank(USER);
        // vm.deal(USER, 1e18);
        //

        // address funder = fundMe.getFunder(0);
        // assertEq(funder, USER);
    }
}
