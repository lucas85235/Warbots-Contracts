// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./Part.sol";

contract IPart {
    function burn(uint256 tokenId) public {}
    function totalSupply() public view virtual returns (uint256) {}
    function ownerOf(uint256 tokenId) public view virtual returns (address) {}
    function balanceOf(address owner) public view virtual returns (uint256) {}
    function isApprovedOrOwner(address spender, uint256 tokenId) external view returns (bool) {}
    function getPart(uint256 tokenID) public view returns (PartContains memory) {}
}

contract Robot is ERC721Enumerable, Ownable {

    using SafeMath for uint256;
    using Strings for string;

    struct Attributes {
        uint256 head;
        uint256 body;
        uint256 armsLeft;
        uint256 armsRight;
        uint256 legs;
    }

    Attributes[] private robots;
    address private partAddress;

    constructor(address _tx) ERC721("Robot", "BOT") {
        setPartAddress(_tx);

        // Robot 0
        mintOwner(0, 0, 0, 0, 0);
    }

    function setPartAddress(address _contract) public onlyOwner {
        partAddress = _contract;
    }

    function mint(uint256 headID, uint256 bodyID, uint256 armsLeftID, uint256 armsRightID, uint256 legsID)
        public returns (bool) {

        require(IPart(partAddress).isApprovedOrOwner(msg.sender, headID), "Caller is not owner nor approved");
        require(IPart(partAddress).isApprovedOrOwner(msg.sender, bodyID), "Caller is not owner nor approved");
        require(IPart(partAddress).isApprovedOrOwner(msg.sender, armsLeftID), "Caller is not owner nor approved");
        require(IPart(partAddress).isApprovedOrOwner(msg.sender, armsRightID), "Caller is not owner nor approved");
        require(IPart(partAddress).isApprovedOrOwner(msg.sender, legsID), "Caller is not owner nor approved");

        require(IPart(partAddress).getPart(headID).partType == PartsType.HEAD, "Not is Head");
        require(IPart(partAddress).getPart(bodyID).partType == PartsType.BODY, "Not is BODY");
        require(IPart(partAddress).getPart(armsLeftID).partType == PartsType.ARMSLEFT, "Not is ARMSLEFT");
        require(IPart(partAddress).getPart(armsRightID).partType == PartsType.ARMSRIGHT, "Not is ARMSRIGHT");
        require(IPart(partAddress).getPart(legsID).partType == PartsType.LEGS, "Not is LEGS");

        IPart(partAddress).burn(headID);
        IPart(partAddress).burn(bodyID);
        IPart(partAddress).burn(armsLeftID);
        IPart(partAddress).burn(armsRightID);
        IPart(partAddress).burn(legsID);

        uint256 newItemID = robots.length;

        robots.push(
            Attributes(
                IPart(partAddress).getPart(headID).serial,
                IPart(partAddress).getPart(bodyID).serial,
                IPart(partAddress).getPart(armsLeftID).serial,
                IPart(partAddress).getPart(armsRightID).serial,
                IPart(partAddress).getPart(legsID).serial
            )
        );

        _safeMint(msg.sender, newItemID);
        return true;
    }

    function mintOwner(uint256 head, uint256 body, uint256 armsLeft, uint256 armsRight, uint256 legs)
        public onlyOwner returns (bool) {

        uint256 newItemID = robots.length;

        robots.push(
            Attributes(
                head,
                body,
                armsLeft,
                armsRight,
                legs
            )
        );

        _safeMint(msg.sender, newItemID);
        return true;
    }

    function getRobotParts(uint256 tokenID) public view returns (Attributes memory) {
        return robots[tokenID];
    }

    function updateHead(uint256 tokenID, uint256 newHead) public {

        require(_isApprovedOrOwner(msg.sender, tokenID), "Not is Owner of this robot!");
        require(IPart(partAddress).isApprovedOrOwner(msg.sender, newHead), "Caller is not owner nor approved");
        require(IPart(partAddress).getPart(newHead).partType == PartsType.HEAD, "Not is Head");

        IPart(partAddress).burn(tokenID);
        robots[tokenID].head = IPart(partAddress).getPart(newHead).serial;
    }

    function getPartOwnerOf(uint256 tokenId) public view virtual returns (address) {
        return IPart(partAddress).ownerOf(tokenId);
    }

    function getPartBalanceOf(address addr) public view virtual returns (uint256) {
        return IPart(partAddress).balanceOf(addr);
    }
}
