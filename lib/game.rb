class Game
  attr_reader :players, :turn_player
  attr_accessor :turn_index

  def initialize(num_of_players: 2)
    @players = []
    @turn_index = 0
    @num_of_players = num_of_players
  end

  def ready?
    players.length == @num_of_players
  end

  def add_player(player)
    @players.push(player)
  end

  def turn_player
    players[turn_index % players.length]
  end

  def next_turn
    self.turn_index += 1
  end
end
