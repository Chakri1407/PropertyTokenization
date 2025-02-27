// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
/**
 * @title PropertyTokenFactory
 * @dev Factory contract for creating new property tokens
 */
contract PropertyTokenFactory is Ownable {
    // Array to store all created property token addresses
    address[] public propertyTokens;
    
    // Mapping to check if a property ID is already used
    mapping(string => bool) public propertyExists;
    
    // Events
    event PropertyTokenCreated(address indexed tokenAddress, string propertyId, string name, string symbol);
    
    /**
     * @dev Constructor sets the contract owner
     */
    constructor() Ownable(msg.sender) {}
    
    /**
     * @dev Create a new property token contract
     * @param _name Token name
     * @param _symbol Token symbol
     * @param _propertyId Unique property identifier
     * @param _propertyValue Property value in wei
     * @param _totalSupply Total number of tokens to mint
     * @param _propertyDocumentHash IPFS hash or other identifier for property documentation
     * @return Address of the newly created token contract
     */
    function createPropertyToken(
        string memory _name,
        string memory _symbol,
        string memory _propertyId,
        uint256 _propertyValue,
        uint256 _totalSupply,
        string memory _propertyDocumentHash
    ) external onlyOwner returns (address) {
        require(!propertyExists[_propertyId], "Property with this ID already exists");
        
        // Create new property token contract
        PropertyToken newToken = new PropertyToken(_name, _symbol);
        
        // Initialize the property
        newToken.initializeProperty(_propertyId, _propertyValue, _totalSupply, _propertyDocumentHash);
        
        // Transfer ownership to the factory owner
        newToken.transferOwnership(owner());
        
        // Mark property as existing
        propertyExists[_propertyId] = true;
        
        // Add to the list of property tokens
        propertyTokens.push(address(newToken));
        
        emit PropertyTokenCreated(address(newToken), _propertyId, _name, _symbol);
        
        return address(newToken);
    }
    
    /**
     * @dev Get the number of property tokens created
     * @return Number of property tokens
     */
    function getPropertyTokenCount() external view returns (uint256) {
        return propertyTokens.length;
    }
    
    /**
     * @dev Get all property token addresses
     * @return Array of property token addresses
     */
    function getAllPropertyTokens() external view returns (address[] memory) {
        return propertyTokens;
    }
}