/*
 SPDX-License-Identifier: MIT
*/
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Part is ERC721Enumerable, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    string[] private robots;
    mapping(uint256 => string) public partNames;

    constructor() ERC721("Warbot Part", "WPT") {
        // Set mapping to convert PartsType to string
        partNames[0] = "HEAD";
        partNames[1] = "BODY";
        partNames[2] = "ARMSLEFT";
        partNames[3] = "ARMSRIGHT";
        partNames[4] = "LEGS";

        // Register initial robots in game
        robots.push("Builderbot");
        robots.push("Elecbot");
        robots.push("Lumberbot");
        robots.push("Stuntbot");
    }

    function mintPart(address _wallet, uint256 amount) public returns (bool) {
        require(amount < 10, "Maximum amount exceeded");
        for (uint256 i = 0; i < amount; i++) {
            _mintPart(_wallet, createRandom(4));
        }
        return true;
    }

    function mintRobot(address _wallet, uint256 amount) public returns (bool) {
        require(amount < 10, "Maximum amount exceeded");
        for (uint256 i = 0; i < amount; i++) {
            _mintPart(_wallet, 0);
            _mintPart(_wallet, 1);
            _mintPart(_wallet, 2);
            _mintPart(_wallet, 3);
            _mintPart(_wallet, 4);
        }
        return true;
    }

    function burn(uint256 _tokenId) public {
        _burn(_tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _mintPart(address _wallet, uint256 partType)
        private
        returns (bool)
    {
        uint256 tokenId = _tokenIdCounter.current();
        uint256 robotIndex = createRandom(robots.length);

        _safeMint(_wallet, tokenId);
        _setTokenURI(
            _tokenIdCounter.current(),
            append(robots[robotIndex], "_", partNames[partType])
        );
        _tokenIdCounter.increment();

        return true;
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // Manage the list of mintable robots

    function getRobotsCount() public view returns (uint256) {
        return robots.length;
    }

    function addRobot(string memory _robot) external onlyOwner {
        robots.push(_robot);
    }

    function removeRobot(uint256 index) external onlyOwner {
        for (uint256 i = index; index < robots.length - 1; i++) {
            robots[i] = robots[i + 1];
        }
        robots.pop();
    }

    function updateRobot(string memory _robot, uint256 index)
        external
        onlyOwner
    {
        require(index < robots.length - 1);
        robots[index] = _robot;
    }

    // Auxiliary Functions

    function createRandom(uint256 number) public view returns (uint256) {
        return
            uint256(keccak256(abi.encodePacked(_tokenIdCounter.current()))) %
            number;
    }

    function append(
        string memory a,
        string memory b,
        string memory c
    ) internal pure returns (string memory) {
        return string(abi.encodePacked(a, b, c));
    }
}
