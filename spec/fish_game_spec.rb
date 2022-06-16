require_relative '../lib/fish_game'
require_relative '../lib/fish_player'
require_relative '../lib/card_deck'
require_relative '../lib/card'

describe 'FishGame' do

  before(:each) do
    @player1, @player2, @player3 = player("William"), player(name: "Braden"), player(name: "Josh")
  end

  it 'Initializes a basic set of instance variables' do
    game = FishGame.new
    expect(game.players).to eq []
    expect(game.deck.card_count).to eq 52
  end

  it 'Initializes a game with optional parameters' do
    deck = CardDeck.new
    game = FishGame.new(deck: deck, players: [@player1, @player2])
    expect(game.players).to eq [@player1, @player2]
    expect(game.players[0].name).to eq "William"
    expect(game.deck).to eq deck
    expect(game.current_player.name).to eq "William"
  end

  it 'starts a game by dealing cards to all players' do
    game = FishGame.new(players: [@player1, @player2, @player3])
    game.start
    (0..2).each { |i| expect(game.players[i].hand.count).to eq FishGame::STARTING_HAND_COUNT }
  end

  it 'runs a round of Go Fish' do
    game = FishGame.new(players: [@player1, @player2])
    game.players[0].hand = [card("Ace", "Club")]
    game.players[1].hand = [card("Ace", "Spades")]
    game.play_round("Ace", @player2)
    expect(game.players[0].hand).to eq [card("Ace", "Club"), card("Ace", "Spades")]
    expect(game.players[0].hand).to eq []
  end



  def card(rank, suit)
    Card.new(rank, suit)
  end

  def player(name)
    FishPlayer.new(name: name)
  end
end