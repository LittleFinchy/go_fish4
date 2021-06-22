require "rspec"
require "../lib/game"

describe("#game") do
  let(:game) { Game.new() }

  it "should start with 0 players" do
    expect(game.players.length).to eq 0
  end

  it "should be able to add a player" do
    game.add_player(Object.new())
    expect(game.players.length).to eq 1
  end

  it "should be not ready to start without the right number of players" do
    expect(game.players.length).to eq 0
    expect(game.ready?).to eq false
  end

  it "should be ready to start when enough players join" do
    game = Game.new(num_of_players: 2)
    game.add_player(Object.new())
    game.add_player(Object.new())
    expect(game.players.length).to eq 2
    expect(game.ready?).to eq true
  end
end
