require 'colorize'
require_relative 'pawn.rb'

class GameBoard
  attr_accessor :GameBoard

  def initialize
    @board = Array.new(8) { |i| i % 2 == 0 ? Array.new(8) {|i| i % 2 == 0 ? '  '.colorize( :background => :black) : '  '.colorize( :background => :white)}: Array.new(8) {|i| i % 2 == 0 ? '  '.colorize( :background => :white) : '  '.colorize( :background => :black)} }
  end

  def display_board
    String.colors
    it = 9
    for array in @board
      it -= 1
      print " #{it} "
      puts array.join('')
    end
    puts "    #{(1..8).to_a.join(' ')}"
  end

  def update_board(board)
    @board = board
  end

  def accurate_positions(x, y)
    array = (1..8).to_a.reverse
    i = array.index(y)
    @board[i][x-1]
  end

  def get_pawn
    pawn = Pawn.new
    pawn.pawn
  end

  def row_of_pawns(x)
    board = @board
    pawn = Pawn.new
    board[0][0] = pawn.pawn
    update_board(board)
  end

end
