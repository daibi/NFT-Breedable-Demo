// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract EightTrigramBase is ERC721URIStorage {
    using Counters for Counters.Counter;

    struct EightTrigramBreedable {
        string upperTrigramGene;
        string lowerTrigramGene;
        string colorFrom;
        string colorTo;
        string zodiacName;
        uint256 fatherTokenId;
        uint256 motherTokenId;
    }

    Counters.Counter public counter;

    EightTrigramBreedable[] public eigthTrigramNFTs;

    address public deployer;

    mapping(address => uint256[]) public ownersTokenIds;
    mapping(uint256 => uint256) public tokenIdToOwnerIndex;

    constructor(string memory _name, string memory _symbol)
        ERC721(_name, _symbol)
    {}

    function setDeployer(address _deployer) internal {
        deployer = _deployer;
    }

    function confirmOwnership(address _owner, uint256 _tokenId) internal {
        require(_owner != address(0x0), "Owner must be valid");

        ownersTokenIds[_owner].push(_tokenId);
        uint256 newTokenIndex = uint256(ownersTokenIds[_owner].length - 1);
        tokenIdToOwnerIndex[_tokenId] = newTokenIndex;
    }

    function create(
        uint256 _fatherTokenId,
        uint256 _motherTokenId,
        string memory _tokenUri,
        string memory _upperTrigramGene,
        string memory _lowerTrigramGene,
        string memory _colorFrom,
        string memory _colorTo,
        string memory _zodiacName,
        address _owner
    ) internal returns (uint256) {
        uint256 currentTokenId = counter.current();
        EightTrigramBreedable memory _newBreedable = EightTrigramBreedable({
            upperTrigramGene: _upperTrigramGene,
            lowerTrigramGene: _lowerTrigramGene,
            colorFrom: _colorFrom,
            colorTo: _colorTo,
            zodiacName: _zodiacName,
            fatherTokenId: _fatherTokenId,
            motherTokenId: _motherTokenId
        });

        _mint(_owner, currentTokenId);
        _setTokenURI(currentTokenId, _tokenUri);
        confirmOwnership(_owner, currentTokenId);
        eigthTrigramNFTs.push(_newBreedable);
        counter.increment();

        return currentTokenId;
    }

    function isApprovedOrOwner(address user, uint256 tokenId)
        public
        view
        virtual
        returns (bool)
    {
        return _isApprovedOrOwner(user, tokenId);
    }

    /**
     * mint gene0 NFT
     *
     */
    function mintGene0(
        string memory _tokenUri,
        string memory _upperTrigramGene,
        string memory _lowerTrigramGene,
        string memory _colorFrom,
        string memory _colorTo,
        string memory _zodiacName
    ) external {
        create(
            0,
            0,
            _tokenUri,
            _upperTrigramGene,
            _lowerTrigramGene,
            _colorFrom,
            _colorTo,
            _zodiacName,
            msg.sender
        );
    }

    function mintGeneN(
        uint256 fatherTokenId,
        uint256 motherTokenId,
        string memory _tokenUri,
        string memory _upperTrigramGene,
        string memory _lowerTrigramGene,
        string memory _colorFrom,
        string memory _colorTo,
        string memory _zodiacName
    ) external {
        create(
            fatherTokenId,
            motherTokenId,
            _tokenUri,
            _upperTrigramGene,
            _lowerTrigramGene,
            _colorFrom,
            _colorTo,
            _zodiacName,
            msg.sender
        );
    }

    modifier onlyDeployer() {
        require(deployer != address(0x0), "Deployer must set first");
        require(msg.sender == deployer, "Must Deployer");
        _;
    }
}
