// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title CustomToken Contract
 * @author  Fadhil& Amschell
 * @notice This contract represents a custom ERC20 token with a transfer fee.
 * @dev The transfer fee is deducted from the transfer amount and sent to a designated fee receiver.
 */

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @notice The CustomToken contract is an ERC20 token that implements a transfer fee mechanism.
 * @dev The contract has three main components: the constructor, the transfer function, and the custom transfer function.
 */
contract CustomToken is ERC20 {
    /**
     * @notice The transfer fee as a percentage of the transfer amount.
     * @dev The fee is calculated as (transfer amount * transferFee) / 100.
     */
    uint256 public transferFee;

    /**
     * @notice The address that receives the transfer fee.
     */
    address public feeReceiver;

    /**
     * @notice Initializes the CustomToken contract.
     * @param name The name of the token.
     * @param symbol The symbol of the token.
     * @param initialSupply The initial supply of the token.
     * @param _transferFee The transfer fee as a percentage.
     * @param _feeReceiver The address that receives the transfer fee.
     * @dev The constructor sets the token's name, symbol, and initial supply, and initializes the transfer fee and fee receiver.
     */
    constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply,
        uint256 _transferFee,
        address _feeReceiver
    ) ERC20(name, symbol) payable {
        /**
         * @notice Sets the transfer fee.
         * @dev The transfer fee is set to the value passed in the constructor.
         */
        transferFee = _transferFee;

        /**
         * @notice Sets the fee receiver.
         * @dev The fee receiver is set to the address passed in the constructor.
         */
        feeReceiver = _feeReceiver;

        /**
         * @notice Mints the initial supply of tokens to the contract deployer.
         * @dev The _mint function is used to mint the initial supply of tokens to the contract deployer.
         */
        _mint(msg.sender, initialSupply);

        /**
         * @notice If the contract is deployed with a non-zero value, transfer it to the fee receiver.
         * @dev This is a precautionary measure to ensure that any accidental Ether sent to the contract is transferred to the fee receiver.
         */
        if (msg.value > 0) {
            payable(feeReceiver).transfer(msg.value);
        }
    }

    /**
     * @notice Transfers tokens from the sender to the recipient.
     * @param recipient The address that receives the tokens.
     * @param amount The amount of tokens to transfer.
     * @return bool Whether the transfer was successful.
     * @dev This function calls the custom transfer function to perform the transfer.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        return _customTransfer(_msgSender(), recipient, amount);
    }

    /**
     * @notice Transfers tokens from the sender to the recipient using an allowance.
     * @param sender The address that owns the tokens.
     * @param recipient The address that receives the tokens.
     * @param amount The amount of tokens to transfer.
     * @return bool Whether the transfer was successful.
     * @dev This function calls the custom transfer function to perform the transfer.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(sender, spender, amount);
        return _customTransfer(sender, recipient, amount);
    }

    /**
     * @notice Custom transfer function that deducts the transfer fee.
     * @param sender The address that owns the tokens.
     * @param recipient The address that receives the tokens.
     * @param amount The amount of tokens to transfer.
     * @return bool Whether the transfer was successful.
     * @dev This function calculates the transfer fee, subtracts it from the transfer amount, and transfers the fee to the fee receiver.
     */
    function _customTransfer(address sender, address recipient, uint256 amount) internal virtual returns (bool) {
        /**
         * @notice Calculate the transfer fee.
         * @dev The transfer fee is calculated as (transfer amount * transferFee) / 100.
         */
        uint256 feeAmount = (amount * transferFee) / 100;

        /**
 * @notice Calculate the amount after deducting the fee.
 * @dev The amount after deducting the fee is calculated by subtracting the fee amount from the transfer amount.
 */
uint256 amountAfterFee = amount - feeAmount;     // Subtract fee from transfer amount

/**
 * @notice Transfer the fee to the fee receiver if it's greater than 0.
 * @dev This ensures that the fee is only transferred if it's a positive value.
 */
if (feeAmount > 0) {
    /**
     * @notice Transfer the fee amount to the fee receiver.
     * @dev The _transfer function is used to transfer the fee amount to the fee receiver.
     */
    _transfer(sender, feeReceiver, feeAmount);
}

/**
 * @notice Transfer the remaining amount to the recipient.
 * @dev The remaining amount after deducting the fee is transferred to the recipient.
 */
_transfer(sender, recipient, amountAfterFee);

/**
 * @notice Return true to indicate that the transfer was successful.
 * @dev This return value indicates that the custom transfer function has completed successfully.
 */
return true;
}
}