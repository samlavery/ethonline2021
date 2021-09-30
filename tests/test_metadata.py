#!/usr/bin/python3
import brownie


def test_metadata_support(nft):
    metadata_interface_id = "0x5b5e139f"
    assert nft.supportsInterface(metadata_interface_id) is True


def test_name_symbol(nft):
    assert nft.name() == "Test NFT"
    assert nft.symbol() == "TEST"


def test_base_uri(nft):
    assert nft.tokenURI() == "metadata"
    #nft.setBaseURI("http://example.com/nfts/")
    #assert nft.baseURI() == "http://example.com/nfts/"


def test_token_uri(nft, accounts):
    nft.mint(accounts[0], 1337)
    assert nft.tokenURI() == "metadata"

    #nft.setBaseURI("http://example.com/nfts/")
    assert nft.tokenURI() == "metadata"


#def test_token_uri_nonexisting(nft):
#    with brownie.reverts("URI query for nonexistent token"):
#        nft.tokenURI(1337)
