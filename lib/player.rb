class Player
  attr_reader :name, :score, :hand

  def initialize(name)
    @name = name
    @score = 0
    @hand = []
  end

  def cards_left
    hand.length
  end

  def take_cards(cards)
    self.hand.concat(cards)
    # check_for_book if hand.length > 0
    # self.hand.shuffle!
  end
end
