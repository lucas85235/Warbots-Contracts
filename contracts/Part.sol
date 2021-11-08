// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

enum PartsType {
    HEAD,
    BODY,
    ARMSLEFT,
    ARMSRIGHT,
    LEGS
}

contract Part is ERC721, Ownable {

    using SafeMath for uint256;
    using Strings for string;

    struct Attributes {
        uint256 serial;
        PartsType partType;
    }

    Attributes[] private parts;
    mapping (address => uint256[]) private partsInWallet;

    constructor() ERC721("Part", "PART") {
        mint(0, PartsType.HEAD);
        mint(0, PartsType.BODY);
        mint(0, PartsType.ARMSLEFT);
        mint(0, PartsType.ARMSRIGHT);
        mint(0, PartsType.LEGS);
    }

    function totalSupply() external view returns (uint256) {
        return parts.length;
    }

    function transferFrom(address from, address to, uint256 tokenId)
        public override {

        super.transferFrom(from, to, tokenId);

        uint256 element;

        for (uint256 i = 0; i < partsInWallet[from].length; i++) {
            if (partsInWallet[from][i] == tokenId) {
                element = i;
            }
        }

        removeInOrder(from, element);
        partsInWallet[to].push(tokenId);
    }

    function mint(uint256 serial, PartsType partType)
        public onlyOwner returns (bool) {

        uint256 newItemID = parts.length;

        parts.push(
            Attributes(serial, partType)
        );

        _safeMint(msg.sender, newItemID);
        partsInWallet[msg.sender].push(newItemID);

        return true;
    }

    function partsList(address from) public view returns (uint256[] memory) {
        return partsInWallet[from];
    }

    function getPart(uint256 tokenID) public view returns (Attributes memory) {
        return parts[tokenID];
    }

    function removeInOrder(address sender, uint256 index) internal {

        for (uint256 i = index; i < partsInWallet[sender].length - 1; i++) {
            partsInWallet[sender][i] = partsInWallet[sender][i + 1];
        }

        partsInWallet[sender].pop();
    }
}