require 'colorize'
require_relative 'pawn.rb'

class GameBoard
  attr_accessor :GameBoard

  def initialize
    @board = Array.new(8) { |i| i % 2 == 0 ? Array.new(8) {|i| i % 2 == 0 ? '   '.colorize( :background => :light_black) : '   '.colorize( :background => :light_magenta)} : Array.new(8) {|i| i % 2 == 0 ? '   '.colorize( :background => :light_magenta) : '   '.colorize( :background => :light_black)} }
  end

  def display_board
    String.colors
    it = 9
    for array in @board
      it -= 1
      print " #{it} "
      puts array.join('')
    end
    puts "    #{(1..8).to_a.join('  ')}"
  end

  def update_board(board)
    @board = board
  end

  def accurate_positions(x, y)
    array = (1..8).to_a.reverse
    i = array.index(y)
    [i, x-1]
  end

  def place_pawn(x, y)
    position = accurate_positions(x, y)
    board = @board
    board[position[0]][position[1]] = Pawn.new(position[0], position[1]).pawn
    update_board(board)
  end

  def toggle_piece(piece)
    position = accurate_positions(piece[0], piece[1])
    if @board[position[0]][position[1]] == '   '.colorize( :background => :light_black) || @board[position[0]][position[1]] == '   '.colorize( :background => :light_magenta)
      puts 'No Piece at location.'
    else
      @board[position[0]][position[1]]
    end
  end

  def move_piece(piece, move_a)
    if piece.move_set(move_a)
      board = @board
      board[move_a[0]][move_a[1]] = piece
      update_board(board)
    else
      puts 'Not a posible move'
    end
  end

  def move
    puts 'Select piece to move.'
    piece = gets.chomp.split('').map(&:to_i)
    toggle = toggle_piece(piece)
    puts 'Select move location.'
    move = gets.chomp.split('').map(&:to_i)
    move_piece(toggle, move)
  end

end
