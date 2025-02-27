// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/**
 * @title PropertyToken
 * @dev ERC20 token representing fractional ownership of a real estate property
 */
contract PropertyToken is ERC20, Ownable {
    // Property metadata
    string public propertyId;
    uint256 public propertyValue;
    address public issuer;
    bool public initialized = false;
    string public propertyDocumentHash;
    
    // Events
    event PropertyInitialized(string propertyId, uint256 propertyValue, uint256 totalSupply, address issuer);
    event PropertyDetailsUpdated(string propertyId, string documentHash);
    
    /**
     * @dev Constructor sets up token name and symbol based on property ID
     * @param _name Name of the token
     * @param _symbol Symbol of the token
     */
    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) Ownable(msg.sender) {}
    
    /**
     * @dev Initialize property details and mint tokens
     * @param _propertyId Unique identifier for the property
     * @param _propertyValue Value of the property in wei
     * @param _totalSupply Total number of tokens to mint
     * @param _propertyDocumentHash IPFS hash or other identifier for property documentation
     */
    function initializeProperty(
        string memory _propertyId,
        uint256 _propertyValue,
        uint256 _totalSupply,
        string memory _propertyDocumentHash
    ) external onlyOwner {
        require(!initialized, "Property already initialized");
        require(_totalSupply > 0, "Total supply must be greater than zero");
        
        propertyId = _propertyId;
        propertyValue = _propertyValue;
        issuer = msg.sender;
        propertyDocumentHash = _propertyDocumentHash;
        initialized = true;
        
        // Mint tokens to the contract owner (admin)
        _mint(msg.sender, _totalSupply);
        
        emit PropertyInitialized(_propertyId, _propertyValue, _totalSupply, msg.sender);
    }
    
    /**
     * @dev Update property documentation hash
     * @param _newDocumentHash Updated IPFS hash or other identifier for property documentation
     */
    function updatePropertyDocumentation(string memory _newDocumentHash) external onlyOwner {
        require(initialized, "Property not initialized");
        propertyDocumentHash = _newDocumentHash;
        
        emit PropertyDetailsUpdated(propertyId, _newDocumentHash);
    }
    
    /**
     * @dev Get token price based on property value and total supply
     * @return Price per token in wei
     */
    function getTokenPrice() public view returns (uint256) {
        require(initialized, "Property not initialized");
        require(totalSupply() > 0, "Total supply is zero");
        
        return propertyValue / totalSupply();
    }
    
    //
    //@dev Get property details
    //@return Property metadata in a structured format
    //
    function getPropertyDetails() external view returns (
        string memory _propertyId,
        uint256 _propertyValue,
        uint256 _totalSupply,
        address _issuer,
        string memory _propertyDocumentHash,
        uint256 _tokenPrice
    ) {
        require(initialized, "Property not initialized");
        
        return (
            propertyId,
            propertyValue,
            totalSupply(),
            issuer,
            propertyDocumentHash,
            getTokenPrice()
        );
    }
}
