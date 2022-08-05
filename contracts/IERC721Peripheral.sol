// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/// @title ERC-721Peripheral Token Extension
/// @dev interfaceId == 0x59b7613c
interface IERC721Peripheral is IERC721 {

		/// @dev This emits when a peripheral token attaches to another token by any mechanism.
		/// @param _tokenId is the peripheral token.
	  /// @param _host The token that receives the child token.
		event Attach(uint256 indexed _tokenId, Host indexed _host);

		/// @dev This emits when a peripheral token detaches by any mechanism.
    /// @param _tokenId is the peripheral token.
    /// @param _newOwner is the token's new Owner
    event Dettach(uint256 indexed _tokenId, address indexed _newOwner);

    struct Host{
        address _address;
        uint256 _tokenId;
    }

		// mapping(uint256 => Host) public bonds;

		/// @dev Attaches a peripheral token `_tokenId` to a host token `_host`.
		///   The contract MUST check if `Hosts` mapping has a `_tokenID` entry
    ///   (a.k.a the token has been attached to a host), and MUST check if
    ///   `msg.sender == ERC721(this).ownerOf(_tokenId)`
    ///   The contract MUST set the owner of token to `address(0)`
		/// @param _tokenId is the peripheral token.
	  /// @param _host The token that receives the child token.
    function attach(uint256 _tokenId, Host calldata _host) external;

		/// @dev Dettaches a peripheral token `_tokenId`
		///  If _host._address is not ERC721Peripheral by checking `supportsInterface`,
    ///  the contract MUST check if the `msg.sender` == `ERC721(_host._address).ownerOf(_host._tokenID)`,
		///  else if _host is ERC721Peripheral, the contract MUST recursively check
    ///  its _host until _host._address is is not ERC721Peripheral.
    ///  The contract MUST delete the entry from `Hosts`, and MUST assign
    ///  the ownership to `newOwner`.
		/// @param _tokenId is the peripheral token.
		/// @param _newOwner is the new owner of the peripheral token.
    function dettach(uint256 _tokenId, address _newOwner) external;
}
