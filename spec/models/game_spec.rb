require "rspec"
require "../lib/game"

describe("#game") do
  let(:game) { Game.new() }

  def make_game_with(num)
    game = Game.new(num_of_players: num)
    num.times do |index|
      game.add_player("Player #{index + 1}")
    end
    game
  end

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

  it "should be ready to start with 2 players unless otherwise told" do
    game.add_player(Object.new())
    game.add_player(Object.new())
    expect(game.players.length).to eq 2
    expect(game.ready?).to eq true
  end

  it "should be ready to start when enough players join" do
    game = make_game_with(3)
    expect(game.players.length).to eq 3
    expect(game.ready?).to eq true
  end

  it "should keep track of the turn player" do
    game = make_game_with(3)
    expect(game.turn_player).to eq "Player 1"
    game.next_turn
    expect(game.turn_player).to eq "Player 2"
    game.next_turn
    expect(game.turn_player).to eq "Player 3"
    game.next_turn
    expect(game.turn_player).to eq "Player 1"
  end
end
