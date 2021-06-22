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
end
