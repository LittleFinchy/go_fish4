class Game
  attr_reader :players, :turn_player
  attr_accessor :turn_index

  def initialize
    @players = []
    @turn_index = 0
  end

  def ready?
    players.length == 2
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
