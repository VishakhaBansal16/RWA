// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract FractionalOwnershipNFT is ERC721URIStorage, Ownable {
    struct FractionalNFT {
        uint256 totalShares;
        uint256 pricePerShare;
        mapping(address => uint256) ownerShares; // Map to track how many shares an address owns
    }

    uint256 public nextTokenId;  // Used to keep track of minted token IDs
    mapping(uint256 => FractionalNFT) public fractionalNFTs; // Mapping of token IDs to fractional NFT details

    event Minted(uint256 indexed tokenId, uint256 totalShares, uint256 pricePerShare, string tokenURI);
    event SharesBought(uint256 indexed tokenId, address indexed buyer, uint256 sharesBought);
    event SharesSold(uint256 indexed tokenId, address indexed seller, uint256 sharesSold);
 
    constructor() ERC721("Fractional Ownership NFT", "FONFT") Ownable(msg.sender) {}

    function mintNFT(address to, string memory tokenURI, uint256 totalShares, uint256 pricePerShare) external onlyOwner {
        require(totalShares > 0, "Total shares must be greater than zero");
        require(pricePerShare > 0, "Price per share must be greater than zero");

        uint256 tokenId = nextTokenId;
        nextTokenId++;

        // Create a new FractionalNFT struct and store it
        FractionalNFT storage newFractionalNFT = fractionalNFTs[tokenId];
        newFractionalNFT.totalShares = totalShares;
        newFractionalNFT.pricePerShare = pricePerShare;

        // Mint the NFT
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);

        emit Minted(tokenId, totalShares, pricePerShare, tokenURI);
    }

    function buyShares(uint256 tokenId, uint256 sharesAmount) external payable {
        FractionalNFT storage fractionalNFT = fractionalNFTs[tokenId];
        
        require(fractionalNFT.totalShares > 0, "Fractional NFT does not exist");
        require(fractionalNFT.ownerShares[msg.sender] + sharesAmount <= fractionalNFT.totalShares, "Not enough shares available");
        require(msg.value == sharesAmount * fractionalNFT.pricePerShare, "Incorrect amount sent");

        // Transfer the shares to the buyer
        fractionalNFT.ownerShares[msg.sender] += sharesAmount;
        fractionalNFT.totalShares -= sharesAmount;

        emit SharesBought(tokenId, msg.sender, sharesAmount);
    }

    function sellShares(uint256 tokenId, uint256 sharesAmount) external {
        FractionalNFT storage fractionalNFT = fractionalNFTs[tokenId];

        require(fractionalNFT.ownerShares[msg.sender] >= sharesAmount, "Not enough shares to sell");
        
        // Calculate the revenue for the seller
        uint256 totalPrice = sharesAmount * fractionalNFT.pricePerShare;

        // Decrease the shares
        fractionalNFT.ownerShares[msg.sender] -= sharesAmount;
        fractionalNFT.totalShares += sharesAmount;

        // Transfer payment to the seller (this would normally involve an escrow or marketplace mechanism)
        payable(msg.sender).transfer(totalPrice); // Send payment to the seller

        emit SharesSold(tokenId, msg.sender, sharesAmount);
    }

    function getShareValue(uint256 tokenId) external view returns (uint256) {
        FractionalNFT storage fractionalNFT = fractionalNFTs[tokenId];
        return fractionalNFT.pricePerShare; // Return the price per share for this tokenId
    }

    function getShareCount(uint256 tokenId, address shareholder) external view returns (uint256) {
        return fractionalNFTs[tokenId].ownerShares[shareholder]; // Returns number of shares an address owns
    }
}