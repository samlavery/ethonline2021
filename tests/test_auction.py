#!/usr/bin/python3

import brownie
import time


def test_auction(auction, accounts):
	tx = auction.bid(1, {'from': accounts[0], "value": 500})
	tx2 = auction.currentBid(1)
	assert tx2.return_value == 500
	tx3 = auction.bid(1, {'from': accounts[0], "value": 501})
	tx4 = auction.currentBid(1)
	assert tx4.return_value == 501

	#assert auction.currentBid(1) == 500


def test_auction_start_end(auction, accounts):
	tx = auction.bid(1, {'from': accounts[0], "value": 500})
	time.sleep(1)
	tx = auction.bid(2, {'from': accounts[0], "value": 1500})
	time.sleep(1)
	tx = auction.bid(1, {'from': accounts[0], "value": 800})
	time.sleep(3)
	tx = auction.endAuction()



#def test_approve_all(nft, accounts):
#    assert nft.isApprovedForAll(accounts[0], accounts[1]) is False
#    nft.setApprovalForAll(accounts[1], True, {'from': accounts[0]})
#    assert nft.isApprovedForAll(accounts[0], accounts[1]) is True
