require "rspec"
require "./lib/deck"

def deal_cards(deck, num)
  cards = []
  num.times do
    cards.push(deck.deal)
  end
  cards
end

describe("#deck") do
  it "should have 52 cards when made" do
    deck = Deck.new()
    expect(deck.cards_left).to eq 52
  end

  it "should deal a card object" do
    deck = Deck.new()
    card = deck.deal
    expect(["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"].include?(card.rank)).to eq true
    expect(deck.cards_left).to eq 51
  end

  it "should shuffle the deck when made" do
    deck = Deck.new()
    cards = deal_cards(deck, 39)
    ranks = []
    cards.each do |card|
      ranks.push(card.rank)
    end
    expect(ranks.uniq.length).to eq 12
  end
end
