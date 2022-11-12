// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./EightTrigramBase.sol";

contract EightTrgramCore is EightTrigramBase {
    constructor() EightTrigramBase("EightTrigramBreedable", "ETB") {
        setDeployer(msg.sender);
    }

    function getOwnerCollectionByIndex(address _owner, uint256 _index)
        external
        view
        returns (
            uint256 fatherTokenId,
            uint256 motherTokenId,
            string memory tokenUri,
            string memory upperTrigramGene,
            string memory lowerTrigramGene,
            string memory colorFrom,
            string memory colorTo,
            string memory zodiacName,
            uint256 tokenId
        )
    {
        uint256 _tokenId = ownersTokenIds[_owner][_index];
        return this.getByTokenId(_tokenId);
    }

    function getByTokenId(uint256 _tokenId)
        external
        view
        virtual
        returns (
            uint256 fatherTokenId,
            uint256 motherTokenId,
            string memory tokenUri,
            string memory upperTrigramGene,
            string memory lowerTrigramGene,
            string memory colorFrom,
            string memory colorTo,
            string memory zodiacName,
            uint256 tokenId
        )
    {
        fatherTokenId = eigthTrigramNFTs[_tokenId].fatherTokenId;
        motherTokenId = eigthTrigramNFTs[_tokenId].motherTokenId;
        tokenUri = this.tokenURI(_tokenId);
        upperTrigramGene = eigthTrigramNFTs[_tokenId].upperTrigramGene;
        lowerTrigramGene = eigthTrigramNFTs[_tokenId].lowerTrigramGene;
        colorFrom = eigthTrigramNFTs[_tokenId].colorFrom;
        colorTo = eigthTrigramNFTs[_tokenId].colorTo;
        zodiacName = eigthTrigramNFTs[_tokenId].zodiacName;
        tokenId = _tokenId;
    }
}
