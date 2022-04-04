require 'colorize'
require_relative 'game_board.rb'
require_relative 'pawn.rb'
require_relative 'king.rb'
require_relative 'knight.rb'
require_relative 'rooke.rb'
require_relative 'bishop.rb'
require_relative 'queen.rb'

class Checkmate < GameBoard
  attr_accessor :state

  def initialize
    @state = false
  end

  def update_state
    @state = false
  end

  def check
end