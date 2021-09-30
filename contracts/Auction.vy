# @version ^0.2.0
# Open Auction

# Auction params
# Beneficiary receives money from the highest bidder
idToWinner: HashMap[uint256, address]
highestBidder: HashMap[uint256, address]
highestBid: HashMap[uint256, uint256]

#beneficiaries(_tokenID uint256): public(idToWinner(address))
auctionStart: public(uint256)
auctionEnd: public(uint256)

# Current state of auction
#highestBidder: public(HashMap[uint256, address])
#highestBid: public(uint256)
beneficiary: address
finalSum: uint256
# Set to true at the end, disallows any change
ended: public(bool)
items: public(uint256)
# Keep track of refunded bids so we can follow the withdraw pattern
pendingReturns: public(HashMap[address, uint256])


# Create a simple auction with `_auction_start` and
# `_bidding_time` seconds bidding time on behalf of the
# beneficiary address `_beneficiary`.
@external
def __init__(_auctionowner: address, _items: uint256, _auction_start: uint256, _bidding_time: uint256):
    self.beneficiary = _auctionowner
    self.items = _items
    self.auctionStart = _auction_start  # auction start time can be in the past, present or future
    self.auctionEnd = self.auctionStart + _bidding_time
    assert block.timestamp < self.auctionEnd # auction end time should be in the future

# Bid on the auction with the value sent
# together with this transaction.
# The value will only be refunded if the
# auction is not won.
@external
@payable
def bid(_tokenID: uint256):
    # Check if bidding period has started.
    assert block.timestamp >= self.auctionStart
    assert _tokenID < self.items
    # Check if bidding period is over.
    assert block.timestamp < self.auctionEnd
    # Check if bid is high enough
    assert msg.value > self.highestBid[_tokenID]
    # Track the refund for the previous high bidder
    self.pendingReturns[self.highestBidder[_tokenID]] += self.highestBid[_tokenID]
    #remove the refund from the sum total
    self.finalSum -= self.highestBid[_tokenID]
    # Assign bid
    self.highestBidder[_tokenID] = msg.sender
    self.highestBid[_tokenID] = msg.value
    # Increment total output
    self.finalSum += msg.value   

@external
def currentBid(_tokenID: uint256) -> uint256:
    assert _tokenID < self.items
    return self.highestBid[_tokenID]



# Withdraw a previously refunded bid. The withdraw pattern is
# used here to avoid a security issue. If refunds were directly
# sent as part of bid(), a malicious bidding contract could block
# those refunds and thus block new higher bids from coming in.
@external
def withdraw():
    send(msg.sender, self.pendingReturns[msg.sender])

# End the auction and send the highest bid
# to the beneficiary.
@external
def endAuction():
    # It is a good guideline to structure functions that interact
    # with other contracts (i.e. they call functions or send Ether)
    # into three phases:
    # 1. checking conditions
    # 2. performing actions (potentially changing conditions)
    # 3. interacting with other contracts
    # If these phases are mixed up, the other contract could call
    # back into the current contract and modify the state or cause
    # effects (Ether payout) to be performed multiple times.
    # If functions called internally include interaction with external
    # contracts, they also have to be considered interaction with
    # external contracts.

    # 1. Conditions
    # Check if auction endtime has been reached
    assert block.timestamp >= self.auctionEnd
    # Check if this function has already been called
    assert not self.ended

    # 2. Effects
    self.ended = True

    # 3. Interaction   
    send(self.beneficiary, self.finalSum)



#Default function
event Payment:
    amount: uint256
    sender: indexed(address)

@external
@payable
def __default__():
    log Payment(msg.value, msg.sender)