// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC721Peripheral.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

abstract contract ERC721Peripheral is ERC721, IERC721Peripheral {

    mapping(uint256 => Host) public bonds;


    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
        return interfaceId == type(IERC721Peripheral).interfaceId || super.supportsInterface(interfaceId);
    }


    // function myiterfaceid() public view returns(bytes4){
    //     return type(IERC721Peripheral).interfaceId;
    // }


    function attach(uint256 _tokenId, Host calldata _host) public virtual {
        require(bonds[_tokenId]._address == address(0), "The token is attached.");
        require(ERC721.ownerOf(_tokenId) == msg.sender,
                "You are not the owner of the token.");
        bonds[_tokenId] = _host;

        ERC721._transfer(msg.sender,_encodeHost(_host), _tokenId);
    }

    function dettach(uint256 _tokenId, address _newOwner) public virtual {
        Host memory _host = bonds[_tokenId];
        address hostAddress = _host._address;
        uint256 hostTokenId = _host._tokenId;

        // do we need to check if host is ERC721?
        while (ERC721(hostAddress).supportsInterface(type(IERC721Peripheral).interfaceId)) {
            (hostAddress, hostTokenId) = ERC721Peripheral(hostAddress).bonds(hostTokenId);
        }
        require(ERC721(hostAddress).ownerOf(hostTokenId) == msg.sender,
                "You are not the root host owner.");

        ERC721._transfer(_encodeHost(_host),_newOwner, _tokenId);
        delete bonds[_tokenId];
    }

    function _beforeTokenTransfer(address from, address to, uint256 _tokenId)
        internal virtual override
    {
        super._beforeTokenTransfer(from, to, _tokenId);
        require(bonds[_tokenId]._address == address(0),
                "This token is attached to a host.");
    }

    function _encodeHost(Host memory _host) internal virtual returns(address){
        return address(ripemd160(abi.encode(_host)));
    }

}
