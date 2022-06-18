require 'card'
require 'fish_game'
require 'fish_player'
require 'fish_game'
require 'card_deck'
require 'pry'

describe FishGame do
  let!(:game) { FishGame.new }
  let(:players) { [FishPlayer.new(name: 'William'), FishPlayer.new(name:'Josh')] }
  describe '#initialize' do
    it 'initializes without error' do
      expect { game }.not_to raise_error
      expect(game.players).to be_empty
      expect(game.deck.cards).to eq CardDeck.new.cards
      expect(game.books).to be_empty
    end

    it 'initializes with given paramaters' do
      game = FishGame.new(players: players ,deck: [card('Ace', 'Spades')]) 
      expect(game.players.count).to be 2
      expect(game.deck).to eq [card('Ace', 'Spades')]
      expect(game.current_player.name).to eq 'William'
    end
  end

  describe '#start' do
    it 'shuffles and deals cards when game is started' do
      game = FishGame.new(players: [FishPlayer.new])
      game.start
      expect(game.players[0].hand_count).to eq FishGame::LESS_THAN_4_STARTING_HAND
    end
  end

  describe '#play_round' do 
    it 'does not get a match from player or fishing' do 
      rigged_game(players: players, deck: [card('2', 'Spades')], hands: [[card('Ace', 'Hearts')], []])
      run_round('A')
      round_result_expectations(player1_end_of_turn_hand: [card('Ace', 'Hearts'), card('2', 'Spades')], round: 1)
    end

    it 'gets a match from fishing' do 
      rigged_game(players: players, deck: [card('Ace', 'Spades')], hands: [[card('Ace', 'Hearts')], []])
      run_round('Ace')
      round_result_expectations(player1_end_of_turn_hand: [card('Ace', 'Spades'), card('Ace', 'Hearts')])
    end
    
    it 'gets a match from the player' do 
      rigged_game(players: players, deck: [card('2', 'Spades')], hands: [[card('Ace', 'Hearts')], [card('Ace', 'Spades')]])
      run_round('Ace')
      round_result_expectations(end_of_turn_deck: [card('2', 'Spades')], player1_end_of_turn_hand: [card('Ace', 'Spades'), card('Ace', 'Hearts')])
    end
    it 'creates a book' do 
      rigged_game(players: players, hands: [[card('Ace', 'Hearts'), card('Ace', 'Clubs'), card('Ace', 'Diamonds'), card('2', 'Spades')], [card('Ace', 'Spades')]])
      run_round('Ace')
      round_result_expectations(player1_end_of_turn_hand: [card('2', 'Spades')], player1_books: ['Aces'])
    end
  end

  describe 'round_pre_check' do 
    it 'if current player hand is empty and deck has cards player goes gets a card' do 
      rigged_game(players: players, deck: [card('Ace', 'Spades')])
      game.round_pre_check
      expect(game.current_player.hand).to eq [card('Ace', 'Spades')]
      expect(game.deck.card_count).to eq 0
    end

    it 'if current player hand is empty and deck has NO cards player goes gets a card' do 
      rigged_game(players: players)
      expect(game.current_player).to eq players[0]
      game.round_pre_check
      expect(game.current_player).to eq players[1] 
    end 
  end

  describe '#game_over?' do 
    it 'returns false if there aren\'t 13 books' do 
      rigged_game(books: [['Aces', '2', '3'], ['Jacks', 'Kings']])
      expect(game.game_over?).to be false
    end
    it 'returns true if there are 13 books' do
      rigged_game(books: [%w( Aces 2 3 4 5 6 ), %w( 7 8 9 10 Jacks Queens Kings )])
      expect(game.game_over?).to be false
    end
  end

  #HELPER METHODS

  def rigged_game(players: [], hands: [[],[]], books: [[],[]], deck: [])
    game.players = players
    game.players.each_with_index do |player, i|
      player.hand = hands[i]
      player.books = books[i]
    end
    game.deck.cards = deck
  end

  def run_round(rank)
    game.play_round(rank, players[1])
  end

  def round_result_expectations(end_of_turn_deck: [], player1_end_of_turn_hand: [], player2_end_of_turn_hand: [], player1_books: [], round: 0)
    expect(game.deck.cards).to eq end_of_turn_deck
    expect(players[0].hand).to eq player1_end_of_turn_hand
    expect(players[0].books).to eq player1_books
    expect(players[1].hand).to eq player2_end_of_turn_hand
    expect(game.round).to eq round
  end

  def card(rank, suit)
    Card.new(rank, suit)
  end


end