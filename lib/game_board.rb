require 'colorize'
require_relative 'pawn.rb'
require_relative 'king.rb'
require_relative 'knight.rb'

class GameBoard
  attr_accessor :player_one, :player_two

  def initialize
    puts 'Player one, please enter your name.'
    @player_one = gets.chomp
    puts 'Player two, please enter your name.'
    @player_two = gets.chomp
    @light_black = '   '.colorize( :background => :light_black)
    @light_magenta = '   '.colorize( :background => :light_magenta)
    @board = Array.new(8) { |i| i % 2 == 0 ? Array.new(8) {|i| i % 2 == 0 ? '   '.colorize( :background => :light_black) : '   '.colorize( :background => :light_magenta)} : Array.new(8) {|i| i % 2 == 0 ? '   '.colorize( :background => :light_magenta) : '   '.colorize( :background => :light_black)} }
  end

  def display_board
    it = 9
    for array in @board
      it -= 1
      print " #{it} "
      n_array = array.map{ |i| i == @light_black || i == @light_magenta ? i = i : i = i.piece}
      puts n_array.join('')
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

  def place_white_pawns
    board = @board
    board[6] = board[6].map.with_index { |slot, i| slot = Pawn.new(6, i, 'white')}
    update_board(board)
  end

  def place_black_pawns
    board = @board
    board[1] = board[1].map.with_index { |slot, i| slot = Pawn.new(1, i, 'black')}
    update_board(board)
  end

  def place_white_back
    board = @board
    board[7][1] = Knight.new(7, 1, 'white')
    board[7][3] = King.new(7, 3, 'white')
    board[7][6] = Knight.new(7, 6, 'white')
    update_board(board)
  end

  def place_black_back
    board = @board
    board[0][1] = Knight.new(0, 1, 'black')
    board[0][3] = King.new(0, 3, 'black')
    board[0][6] = Knight.new(0, 6, 'black')
    update_board(board)
  end
  
  def set_board
    place_white_pawns
    place_black_pawns
    place_white_back
    place_black_back
  end

  def toggle_piece(piece, player)
    position = accurate_positions(piece[0], piece[1])
    if @board[position[0]][position[1]] == @light_black || @board[position[0]][position[1]] == @light_magenta
      puts 'No Piece at location.'
    elsif player == @player_one
      if @board[position[0]][position[1]].team == 'white'
        @board[position[0]][position[1]]
      else
        puts 'Not your piece'
      end
    else
      if @board[position[0]][position[1]].team == 'black'
        @board[position[0]][position[1]]
      else
        puts 'Not your piece'
      end
    end
  end

  def move_piece(piece, move_a)
    position = accurate_positions(move_a[0], move_a[1])
    last_position = piece.position
    if piece.move_set(position) && (@board[position[0]][position[1]] == @light_black || @board[position[0]][position[1]] == @light_magenta)
      piece.position = piece.update_position(position)
      piece.piece = piece.update_piece
      board = @board
      board[position[0]][position[1]] = piece
      board[last_position[0]][last_position[1]] = last_position[0] % 2 == 0 ? (last_position[1] % 2 == 0 ? "   ".colorize( :background => :light_black)  : "   ".colorize( :background => :light_magenta)) : (last_position[1] % 2 == 0 ? "   ".colorize( :background => :light_magenta)  : "   ".colorize( :background => :light_black))
      update_board(board)
      true
    else
      false
    end
  end

  def attack_piece(piece, move_a)
    position = accurate_positions(move_a[0], move_a[1])
    last_position = piece.position
    if @board[position[0]][position[1]] != @light_black && @board[position[0]][position[1]] != @light_magenta && @board[position[0]][position[1]] != nil
      if @board[position[0]][position[1]].team != piece.team
        # if @board[position[0]][position[1] != nil
          if piece.attack_set(position) 
            piece.position = piece.update_position(position)
            piece.piece = piece.update_piece
            board = @board
            board[position[0]][position[1]] = piece
            board[last_position[0]][last_position[1]] = last_position[0] % 2 == 0 ? (last_position[1] % 2 == 0 ? "   ".colorize( :background => :light_black)  : "   ".colorize( :background => :light_magenta)) : (last_position[1] % 2 == 0 ? "   ".colorize( :background => :light_magenta)  : "   ".colorize( :background => :light_black))
            update_board(board)
            true
          end
        # end
      end
    else
      false
    end
  end

  def move(player)
    puts "#{player}, select piece to move."
    piece = gets.chomp.split('').map(&:to_i)
    toggle = toggle_piece(piece, player)
    puts 'Select move location.'
    move = gets.chomp.split('').map(&:to_i)
    if move_piece(toggle, move)
    elsif attack_piece(toggle, move)
    else
      puts 'Not a valid move.'
    end
  end

end
