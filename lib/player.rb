class Player
  attr_reader :name, :score
  attr_accessor :id, :hand

  def initialize(name)
    @name = name
    @score = 0
    @id = id
    @hand = []
  end

  def cards_left
    hand.length
  end

  def take_cards(cards)
    self.hand.concat(cards)
    # check_for_book if hand.length > 0
  end
end
