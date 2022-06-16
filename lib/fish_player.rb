# frozen_string_literal: true
require 'pry'

class FishPlayer
  attr_accessor :name, :books, :hand
  def initialize(name: 'Random Player', books:  [], hand: [])
      @name = name
      @books = books
      @hand = hand
  end
  
  def take_cards(*cards)
    cards = cards.flatten.each { |card| hand.push(card) }
    create_books
    cards
  end

  def give_cards_by_rank(rank)
     cards = hand.each {|card| card.rank == rank }
     hand.delete_if {|card| card.rank == rank}
     cards
  end

  def create_books
    hand_ranks = hand.map { |card| card.rank}
    Card::RANKS.each do |rank|
      if hand_ranks.count { |card_rank| rank == card_rank} > 3
         hand.delete_if {|card| card.rank == rank}
         books.push("#{rank}s")
      end
    end
  end

  def book_count
    books.count 
  end

end