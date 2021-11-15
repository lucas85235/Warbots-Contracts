// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

enum PartsType {
    HEAD,
    BODY,
    ARMSLEFT,
    ARMSRIGHT,
    LEGS
}

struct PartContains {
    uint256 serial;
    PartsType partType;
}

contract Part is ERC721Enumerable {

    using SafeMath for uint256;
    using Strings for string;

    PartContains[] private parts;

    constructor() ERC721("Part", "PART") {
        // Robot 0
        mint(0, PartsType.HEAD);
        mint(0, PartsType.BODY);
        mint(0, PartsType.ARMSLEFT);
        mint(0, PartsType.ARMSRIGHT);
        mint(0, PartsType.LEGS);

        // Robot 1
        mint(1, PartsType.HEAD);
    }

    function mint(uint256 serial, PartsType partType) public returns (bool) {

        // Regra de Acesso ao metodo?
        // Pool limite para a criação?
        // Mint de parte por parte ou cinco partes
        // Mint de partes Aleatorias?

        uint256 newItemID = parts.length;

        parts.push(
            PartContains(serial, partType)
        );

        _safeMint(msg.sender, newItemID);
        return true;
    }

    function burn(uint256 tokenId) public {
        _burn(tokenId);
    }

    function getPart(uint256 tokenID) public view returns (PartContains memory) {
        return parts[tokenID];
    }

    function isApprovedOrOwner(address spender, uint256 tokenId) external view returns (bool) {
        bool result = _isApprovedOrOwner(spender, tokenId);
        return result;
    }
}