require 'colorize'
require 'cardcollection'


class Deck < CardCollection
  attr_reader :cards

  def initialize
    @cards = Array.new
    (0...13).each do |rank|
      (0...4).each do |suit|
        @cards << Card.new(rank, suit)
      end
    end
  end

  def draw
    @cards.pop
  end

  def shuffle!
    @cards.shuffle!
  end
end
