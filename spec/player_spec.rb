describe 'Player' do
  let(:player) { Player.new("Herbert", 100_000) }

  describe '#initialize' do
    it 'sets player\'s name' do
      expect(player.name).to equal("Herbert")
    end

    it 'sets player\'s pot' do
      expect(player.pot).to equal(100_000)
    end

    it 'gives the player and empty hand' do
      expect(player.hand.cards).to be_empty
    end
  end

  describe '#decide_action' do
    #STDIN/OUT beyond current capabilities.
  end

  describe '#deal_cards' do
    it 'adds cards to player\'s hand' do
      player.deal_cards(nil, nil, nil, nil, nil)
      expect(player.hand.count).to eq(5)
    end
  end

  describe '#discard_cards' do
    #STDIN/OUT beyond current capabilities
  end

end
