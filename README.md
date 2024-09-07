CustomToken README
Introduction
The CustomToken contract is an ERC20 token that implements a transfer fee mechanism. This contract allows for the creation of a custom token with a transfer fee that is deducted from the transfer amount and sent to a designated fee receiver.

Contract Overview
The CustomToken contract has three main components:

Constructor
The constructor initializes the contract with the token's name, symbol, initial supply, transfer fee, and fee receiver.

Transfer Function
The transfer function allows users to transfer tokens from one address to another. The function deducts the transfer fee from the transfer amount and sends it to the fee receiver.

Custom Transfer Function
The custom transfer function is an internal function that calculates the transfer fee, subtracts it from the transfer amount, and transfers the fee to the fee receiver.

Variables
transferFee
The transfer fee as a percentage of the transfer amount.

feeReceiver
The address that receives the transfer fee.

Functions
constructor
Initializes the contract with the token's name, symbol, initial supply, transfer fee, and fee receiver.

transfer
Transfers tokens from the sender to the recipient.

transferFrom
Transfers tokens from the sender to the recipient using an allowance.

_customTransfer
The custom transfer function that deducts the transfer fee.

Usage
To use the CustomToken contract, follow these steps:

Deploy the contract with the desired token name, symbol, initial supply, transfer fee, and fee receiver.
Use the transfer or transferFrom function to transfer tokens between addresses.
The contract will automatically deduct the transfer fee and send it to the fee receiver.
