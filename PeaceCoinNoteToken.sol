pragma solidity ^0.6.0;

import "./AccessControl.sol";
import "./Context.sol";
import "./ERC20.sol";
import "./ERC20Burnable.sol";
import "./ERC20Pausable.sol";

/**
 * @dev {ERC20} Peace Coin Note Token
 *
 * REACH, to the Future of this Planet.
 * Richness cannot be measured by the amount of money.
 * If you can get anything you want,
 * and if you can go anywhere you want to, is it enough? 
 * You cannot feel “rich” without sharing your time or feelings with someone…
 * That is the reason why people support and cuddle each other.
 * Appreciate small happiness around us.
 * Then pass it to somebody next to you.
 * Somebody close to you, 
 * or somebody in the world, even if you haven’t met…
 * If every person passes “ARIGATO” one by one,
 * Our future should be much richer…
 * We will hold richness that we haven’t experienced yet…
 * With PEACE COIN.
 * Across borders and across the sea,
 * Reach, to the future of this planet.
 *
 */
contract PeaceCoinNoteToken is Context, AccessControl, ERC20Burnable, ERC20Pausable {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    
    // Peace Coin Note Settings
    uint8 constant DECIMALS = 18;
    uint constant MINT_END_TIME = 1767193199; // 2025/12/31-23:59:59 (UTC UNIX TIME)
    uint constant TOKEN_CAP = 100000000000 * 10 ** uint256(DECIMALS);


    /**
     * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
     * account that deploys the contract.
     *
     * See {ERC20-constructor}.
     */
    constructor(string memory name, string memory symbol) public ERC20(name, symbol) {
        _setupDecimals(DECIMALS);
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(MINTER_ROLE, _msgSender());
        _setupRole(PAUSER_ROLE, _msgSender());
    }

    /**
     * @dev Creates `amount` new tokens for `to`.
     *
     * See {ERC20-_mint}.
     *
     * Requirements:
     *
     * - the caller must have the `MINTER_ROLE`.
     */
    function mint(address to, uint256 amount) public {
        
        require(hasRole(MINTER_ROLE, _msgSender()), "ERC20MinterPauser: must have minter role to mint");
        
        // After 2026/12/31-23:59:59(UTC UNIX TIME 1798729190) is arrived, the mint() function will not work anymore.
        require(block.timestamp <= MINT_END_TIME);
        
        // Peace Coin Token Total Supply is up to 100,000,000,000 token.
        require(totalSupply() < TOKEN_CAP);
        
        _mint(to, amount);
    }

    /**
     * @dev Pauses all token transfers.
     *
     * See {ERC20Pausable} and {Pausable-_pause}.
     *
     * Requirements:
     *
     * - the caller must have the `PAUSER_ROLE`.
     */
    function pause() public {
        require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20MinterPauser: must have pauser role to pause");
        _pause();
    }

    /**
     * @dev Unpauses all token transfers.
     *
     * See {ERC20Pausable} and {Pausable-_unpause}.
     *
     * Requirements:
     *
     * - the caller must have the `PAUSER_ROLE`.
     */
    function unpause() public {
        require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20MinterPauser: must have pauser role to unpause");
        _unpause();
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC20, ERC20Pausable) {
        super._beforeTokenTransfer(from, to, amount);
    }
}
