require_relative '../lib/fish_player'
require_relative '../lib/card'

describe 'FishPlayer' do
  describe '#initialize' do 
    it 'Initializes a basic set of instance variables' do
      player = FishPlayer.new
      expect(player.name).to eq ''
      expect(player.hand).to eq []
      expect(player.books).to eq []
    end
  

    it 'Initializes a player with optional parameters' do
      player = FishPlayer.new(name: "William", hand: [card("Ace", "Spade"), card("2", "Club")], books: ["King"])
      expect(player.name).to eq "William"
      expect(player.hand).to eq [card("Ace", "Spades"), card("2", "Clubs")]
      expect(player.books).to eq ["King"]
    end
  end
  describe '#takes_cards' do 
    it 'Takes cards from game' do
      player = FishPlayer.new
      player.take_cards([card("Ace", "Spade"), card("2", "Club")])
      expect(player.hand).to eq [card("Ace", "Spade"), card("2", "Club")]
      player.take_cards([card("2", "Spade"), card("3", "Club")])
      expect(player.hand).to eq [card("Ace", "Spade"), card("2", "Club"), card("2", "Spade"), card("3", "Club")]
    end
  end
  describe '#give_cards_by_rank' do
    it 'Gives cards to the game' do
      player = FishPlayer.new(hand: [card("Ace", "Spade"), card("2", "Club"), card("2", "Diamond")])
      expect(player.give_cards_by_rank("Ace")[0]).to eq card("Ace", "Spade")
      expect(player.hand).to eq [card("2", "Club"), card("2", "Diamond")]
      expect(player.give_cards_by_rank("2")[0]).to eq card("2", "Club")
      expect(player.hand).to eq []
    end
  end
  describe '#book_creator' do
    it 'Can identify books in hand and save them into books' do
      player = FishPlayer.new(hand: [card("2", "Spade"), card("2", "Club"), card("2", "Diamond")])
      expect(player.book_count).to eq 0
      player.take_cards([card("Ace", "Heart"), card("2", "Club")])
      expect(player.books).to eq ["2s"]
      expect(player.hand).to eq [card("Ace", "Heart")]
      expect(player.book_count).to eq 1
    end
  end

    def card(rank, suit)
        Card.new(rank, suit)
    end
end