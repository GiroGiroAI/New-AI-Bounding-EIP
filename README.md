## Abstract

> *Abstract is a multi-sentence (short paragraph) technical summary. This should be a very terse and human-readable version of the specification section. Someone should be able to read only the abstract to get the gist of what this specification does.*
> 

The extension allows an ERC-721 token $Y$ to be attached to another ERC-721 token $X$. The peripheral token $Y$ has two states: `attached` and `detached`. $Y$ is **only** transferable and free to attach to any token when `detached`. In a nested attachment $(Z \rightarrow Y \rightarrow X)$,  only $X$’s owner can set $Y$ and $Z$ to `detached`.

## **Motivation**

> *The motivation section should describe the "why" of this EIP. What problem does it solve? Why should someone want to implement this standard? What benefit does it provide to the Ethereum ecosystem? What use cases does this EIP address?*
> 

This EIP helps GiroGiro.AI to bound AI models to NFTs in the form of SoulBoundToken, which is not transferrable nor tradable, positioning the AI model as the brain/soul of the related NFTs. This SBT idea is different from the concept brought up by Vitalik which stresses on the connection between SBT and a wallet.

This EIP introduces a new tokenomics hierarchy, a unidirectional relationship from a peripheral token $Z$ to an intermediate host/peripheral token $Y$ to a root host token $X$. The simplified unidirectional relationship opens many opportunities for peripheral token designers and enhances the functionalities of the existing and future tokens. In particular, the peripheral token designers have complete flexibility in creating digital assets without any action required from the host token sponsors. 

For example, in a decentralized RPG GameFi world, the blacksmith can create weapons and armors (token $Y$) autonomously for characters (token $X$), and the gem maker can carve stones (token $Z$) to enhance weapons and armors (token $Y$) without any intervention from the blacksmith. This EIP intentionally ignores a top-down (centralized) relationship where the host token dictates the attached token’s specification. In true decentralization, the peripheral token extension facilitates user-generated content creation and enriches the host token’s functionalities and desirability.

Furthermore, this EIP unleashes the value of individual creators. Users can create a series of NFTs, for example, in-game items, and associate them with existing NFTs. This is done by assigning previously existing NFTs as host tokens to the user-generated series of NFTs. Using the RPG GameFi mentioned above as an example, every individual creator can become a blacksmith and create weapons and armor (NFTs) and airdrop to a character designed by the GameFi, which in this case, will be the host token. Once the dApp approves this relationship, the weapons and armor (NFT airdrops) can be pulled from the smart contract and be revealed in-game, with a unidirectional relationship.

## **Specification**

> *The technical specification should describe the syntax and semantics of any new feature. The specification should be detailed enough to allow competing, interoperable implementations for any of the current Ethereum platforms (go-ethereum, parity, cpp-ethereum, ethereumj, ethereumjs, and [others](https://github.com/ethereum/wiki/wiki/Clients)).*
> 

The key words “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “MAY”, and “OPTIONAL” in this document are to be interpreted as described in RFC 2119.

**Every ERC-721Peripheral compliant contract must implement the `ERC721` and `ERC165` interfaces.**

```solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title ERC-721Peripheral Token Extension
/// @dev Required interface of an ERC721Peripheral compliant contract.
///   interfaceId == 0x59b7613c
///   The contract MUST maintain the token's state
interface IERC721Peripheral is IERC165, IERC721 {

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

		/// @dev Attaches a peripheral token `_tokenId` to a host token `_host`.
		///   The contract MUST check if `Hosts` mapping has a `_tokenID` entry
    ///   (a.k.a the token has been attached to a host), and MUST check if
    ///   `msg.sender == ERC721(this).ownerOf(_tokenId)`
    ///   The contract MUST set the owner of the token to the encoded address of `_host`
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
    function detach(uint256 _tokenId, address _newOwner) external;
}
```

Borrowing the idea from World of Warcraft, there are two variances of peripheral token: **tradable** and **soulbound**. For simplicity, we define the tradable peripheral token as the generalized specification, and the soulbound peripheral token is the special case.

### Soulbound

```solidity
function detach(uint256 tokenId) public override {
    revert("This is a soulbond token.");
}
```

## **Rationale**

> *The rationale fleshes out the specification by describing what motivated the design and why particular design decisions were made. It should describe alternate designs that were considered and related work, e.g. how the feature is supported in other languages.*
> 

The EIP intentionally ignores a top-down relationship where the host token can actively attach a  peripheral token for the following reasons:

- It is almost impossible to alter the existing host token’s implementation to extend the attachability.
- The dictated specification from the host token misaligns our belief in decentralization.
- Introducing two ideas in a single EIP is not recommended in EIP-1.

The EIP is also a generalization of soulbound token-to-token. As demonstrated in the previous section,  the EIP becomes a soulbound token-to-token with shielded `detach()`.

## **Backwards Compatibility**

> *All EIPs that introduce backwards incompatibilities must include a section describing these incompatibilities and their severity. The EIP must explain how the author proposes to deal with these incompatibilities. EIP submissions without a sufficient backwards compatibility treatise may be rejected outright.*
> 

The EIP is fully backward compatible with EIP-721

## **Test Cases**

Test cases for an implementation are mandatory for EIPs that are affecting consensus changes. If the test suite is too large to reasonably be included inline, then consider adding it as one or more files in `../assets/eip-####/`.

## **Reference Implementation**

> An optional section that contains a reference/example implementation that people can use to assist in understanding or implementing this specification. If the implementation is too large to reasonably be included inline, then consider adding it as one or more files in `../assets/eip-####/`.
> 

```solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC721Peripheral.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

abstract contract ERC721Peripheral is ERC721, IERC721Peripheral {

    mapping(uint256 => Host) public bonds;

    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
        return interfaceId == type(IERC721Peripheral).interfaceId || super.supportsInterface(interfaceId);
    }

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

```

## Security Considerations

> All EIPs must contain a section that discusses the security implications/considerations relevant to the proposed change. Include information that might be important for security discussions, surfaces risks and can be used throughout the life cycle of the proposal. E.g. include security-relevant design decisions, concerns, important discussions, implementation-specific guidance and pitfalls, an outline of threats and risks and how they are being addressed. EIP submissions missing the "Security Considerations" section will be rejected. An EIP cannot proceed to status "Final" without a Security Considerations discussion deemed sufficient by the reviewers.
> 

In `attach()`, the contract MUST set the token's owner to the encoded address of `_host`. An example implementation may be `address(ripemd160(abi.encode(_host)))`. The address space is still considered large enough to avoid a collision. The security guarantee is the same as creating a new address. 

## **Copyright**

Copyright and related rights waived via [CC0](https://github.com/ethereum/EIPs/blob/LICENSE.md).
