require "./lib/deck"

class Game
  attr_reader :players, :turn_player, :num_of_players, :deck
  attr_accessor :turn_index

  def initialize(num_of_players: 2)
    @players = []
    @turn_index = 0
    @num_of_players = num_of_players
    @deck = Deck.new()
  end

  def ready?
    players.length == num_of_players
  end

  def add_player(player)
    player.id = players.length
    deal(player)
    @players.push(player)
  end

  def deal(player)
    starting_cards = 5.times.map { deck.deal }
    player.take_cards(starting_cards)
  end

  def turn_player
    players[turn_index % players.length]
  end

  def not_turn_players
    players - [turn_player]
  end

  def next_turn
    self.turn_index += 1
  end
end
