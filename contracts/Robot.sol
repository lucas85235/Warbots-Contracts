// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./Part.sol";

contract MyPart {
    function totalSupply() external view returns (uint256) {}
    function transferFrom(address from, address to, uint256 tokenId) public {}
    function mint(uint256 serial, PartsType partType) public returns (bool) {}
    function partsList(address from) public view returns (uint256[] memory) {}
    function getPart(uint256 tokenID) public view returns (PartContains memory) {}
    function removeInOrder(address sender, uint256 index) internal {}
    function isApprovedOrOwner(address spender, uint256 tokenId) external view returns (bool) {}
    function burn(uint256 tokenId) public {}
}

contract Robot is ERC721, Ownable {

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
    mapping (address => uint256[]) private robotsInWallet;
    MyPart private partAddress;

    constructor(address part) ERC721("Robot", "BOT") {
        partAddress = MyPart(part);
        mint(0, 1, 2, 3, 4);
    }

    function setMyPartContract(address _t) public {
        partAddress = MyPart(_t);
    }

    function partTotalSupply() external view returns (uint256) {
        return partAddress.totalSupply();
    }

    function totalSupply() external view returns (uint256) {
        return robots.length;
    }

    function transferFrom(address from, address to, uint256 tokenId)
        public override {

        super.transferFrom(from, to, tokenId);

        uint256 element;

        for (uint256 i = 0; i < robotsInWallet[from].length; i++) {
            if (robotsInWallet[from][i] == tokenId) {
                element = i;
            }
        }

        removeInOrder(from, element);
        robotsInWallet[to].push(tokenId);
    }

    function mint(uint256 headID, uint256 bodyID, uint256 armsLeftID, uint256 armsRightID, uint256 legsID)
        public returns (bool) {

        // id da parte
        // saber se e do tipo correspondente
        // e se o sender e o dono da parte

        require(partAddress.isApprovedOrOwner(msg.sender, headID), "Caller is not owner nor approved");
        require(partAddress.isApprovedOrOwner(msg.sender, bodyID), "Caller is not owner nor approved");
        require(partAddress.isApprovedOrOwner(msg.sender, armsLeftID), "Caller is not owner nor approved");
        require(partAddress.isApprovedOrOwner(msg.sender, armsRightID), "Caller is not owner nor approved");
        require(partAddress.isApprovedOrOwner(msg.sender, legsID), "Caller is not owner nor approved");

        require(partAddress.getPart(headID).partType == PartsType.HEAD, "Not is Head");
        require(partAddress.getPart(bodyID).partType == PartsType.BODY, "Not is BODY");
        require(partAddress.getPart(armsLeftID).partType == PartsType.ARMSLEFT, "Not is ARMSLEFT");
        require(partAddress.getPart(armsRightID).partType == PartsType.ARMSRIGHT, "Not is ARMSRIGHT");
        require(partAddress.getPart(legsID).partType == PartsType.LEGS, "Not is LEGS");

        // partAddress.transferFrom(msg.sender, address(0), headID);
        // partAddress.burn(bodyID);
        // partAddress.burn(armsLeftID);
        // partAddress.burn(armsRightID);
        // partAddress.burn(legsID);

        uint256 newItemID = robots.length;

        robots.push(
            Attributes(
                partAddress.getPart(headID).serial,
                partAddress.getPart(bodyID).serial,
                partAddress.getPart(armsLeftID).serial,
                partAddress.getPart(armsRightID).serial,
                partAddress.getPart(legsID).serial
            )
        );

        // partAddress.transferFrom(msg.sender, address(0))

        _safeMint(msg.sender, newItemID);
        robotsInWallet[msg.sender].push(newItemID);

        return true;
    }

    function robotsList(address from) public view returns (uint256[] memory) {
        return robotsInWallet[from];
    }

    function getRobotParts(uint256 tokenID) public view returns (Attributes memory) {
        return robots[tokenID];
    }

    function removeInOrder(address sender, uint256 index) internal {

        for (uint256 i = index; i < robotsInWallet[sender].length - 1; i++) {
            robotsInWallet[sender][i] = robotsInWallet[sender][i + 1];
        }

        robotsInWallet[sender].pop();
    }

    function updateHead(uint256 tokenID, uint256 newHead) public {

        // receber uma part do mesmo tipo como parametro
        // vericar se essa parte e do mesmo propietario do sender
        // enviar a part de parametro para o endereço de queima

        require(ownerOf(tokenID) == msg.sender, "Not is owner of this nft!");
        require(partAddress.isApprovedOrOwner(msg.sender, newHead), "Caller is not owner nor approved");
        require(partAddress.getPart(newHead).partType == PartsType.HEAD, "Not is Head");

        // robots[tokenID].head = newHead;
        partAddress.burn(newHead);
    }

    // separar peças do robor e mintar/devolver partes do mesmo

    // criar de mintar o nft que
    // receber partes como parametro
    // vericar se essas partes são do mesmo propietario do sender
    // enviar as partes para o endereço de queima

}
