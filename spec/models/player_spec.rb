require "rspec"
require "../lib/player"
# require "../lib/card"

describe("#player") do
  let(:player) { Player.new("Joe") }

  it "should have a name" do
    expect(player.name).to eq "Joe"
  end

  it "should have a score of 0 when made" do
    expect(player.score).to eq 0
  end

  it "should have an empty hand when made" do
    expect(player.hand).to eq []
  end

  context "#take_cards" do
    it "can take a card and add it to hand" do
      card = Object.new()
      player.take_cards([card])
      expect(player.hand.include?(card)).to eq true
    end

    it "can take two cards and add them to hand" do
      card1 = Object.new()
      card2 = Object.new()
      player.take_cards([card1, card2])
      expect(player.hand.length).to eq 2
    end
  end
end
