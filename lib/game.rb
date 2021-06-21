class Game
  attr_reader :players

  def initialize
    @players = []
  end

  def ready?
    players.length == 2
  end

  def add_player(player)
    @players.push(player)
  end

  def turn_player
    players[0]
  end
end
