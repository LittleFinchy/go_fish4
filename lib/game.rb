class Game
  attr_reader :players

  def initialize
    @players = []
  end

  def add_player(player)
    @players.push(player)
  end
end
