class CardCollection
  attr_reader :cards
    
  def empty?
    @cards.empty?
  end

  def count(&prc)
    @cards.count(&prc)
  end

end
