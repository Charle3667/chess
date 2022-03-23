require 'colorize'
require_relative 'pawn.rb'
require_relative 'king.rb'
require_relative 'knight.rb'
require_relative 'rooke.rb'
require_relative 'bishop.rb'
require_relative 'queen.rb'

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
    board[7][0] = Rooke.new(7, 0, 'white')
    board[7][1] = Knight.new(7, 1, 'white')
    board[7][2] = Bishop.new(7, 2, 'white')
    board[7][3] = King.new(7, 3, 'white')
    board[7][4] = Queen.new(7, 4, 'white')
    board[7][5] = Bishop.new(7, 5, 'white')
    board[7][6] = Knight.new(7, 6, 'white')
    board[7][7] = Rooke.new(7, 7, 'white')
    update_board(board)
  end

  def place_black_back
    board = @board
    board[0][0] = Rooke.new(0, 0, 'black')
    board[0][1] = Knight.new(0, 1, 'black')
    board[0][2] = Bishop.new(0, 2, 'black')
    board[0][3] = King.new(0, 3, 'black')
    board[0][4] = Queen.new(0, 4, 'black')
    board[0][5] = Bishop.new(0, 5, 'black')
    board[0][6] = Knight.new(0, 6, 'black')
    board[0][7] = Rooke.new(0, 7, 'black')
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

  def free_spaces_h_V(piece)
    position = accurate_positions(piece[0], piece[1])
    right = free_spaces_right(position)
    left = free_spaces_left(position)
    up = free_spaces_up(position)
    down = free_spaces_down(position)
    free_spaces = [right, left, up, down]
    while (@board[right[0]][right[1]] == @light_black || @board[right[0]][right[1]] == @light_magenta)
      right = free_spaces_right(right)
      free_spaces.push(right)
    end
    while (@board[left[0]][left[1]] == @light_black || @board[left[0]][left[1]] == @light_magenta) && left[1] >= 0
      left = free_spaces_left(left)
      free_spaces.push(left)
    end
    while (@board[up[0]][up[1]] == @light_black || @board[up[0]][up[1]] == @light_magenta) && up[0] >= 0
      up = free_spaces_up(up)
      free_spaces.push(up)
    end
    if down[0] < 7
      while (@board[down[0]][down[1]] == @light_black || @board[down[0]][down[1]] == @light_magenta) && down[0] < 7
        down = free_spaces_down(down)
        free_spaces.push(down)
      end
    end
    free_spaces
  end

  def free_spaces_right(right)
    [right[0], (right[1] + 1)]
  end

  def free_spaces_left(left)
    [left[0], (left[1] - 1)]
  end

  def free_spaces_up(up)
    [(up[0] - 1), (up[1])]
  end

  def free_spaces_down(down)
    [(down[0] + 1), (down[1])]
  end





  def free_spaces_d(piece)
    position = accurate_positions(piece[0], piece[1])
    up_right = free_spaces_up_right(position)
    up_left = free_spaces_up_left(position)
    down_right = free_spaces_down_right(position)
    down_left = free_spaces_down_left(position)
    free_spaces = [up_right, up_left, down_right, down_left]
    while (@board[up_right[0]][up_right[1]] == @light_black || @board[up_right[0]][up_right[1]] == @light_magenta) && up_right[1] >= 0
      up_right = free_spaces_up_right(up_right)
      free_spaces.push(up_right)
    end
    while (@board[up_left[0]][up_left[1]] == @light_black || @board[up_left[0]][up_left[1]] == @light_magenta) && up_left[1] >= 0
      up_left = free_spaces_up_left(up_left)
      free_spaces.push(up_left)
    end
    if down_right[0] < 7
      while (@board[down_right[0]][down_right[1]] == @light_black || @board[down_right[0]][down_right[1]] == @light_magenta) && down_right[0] < 7
        down_right = free_spaces_down_right(down_right)
        free_spaces.push(down_right)
      end
    end
    if down_left[0] < 7
      while (@board[down_left[0]][down_left[1]] == @light_black || @board[down_left[0]][down_left[1]] == @light_magenta) && down_left[0] < 7
        down_left = free_spaces_down_left(down_left)
        free_spaces.push(down_left)
      end
    end
    free_spaces
  end

  def free_spaces_up_right(up_right)
    [(up_right[0] - 1), (up_right[1] + 1)]
  end

  def free_spaces_up_left(up_left)
    [(up_left[0] - 1), (up_left[1] - 1)]
  end

  def free_spaces_down_right(down_right)
    [(down_right[0] + 1), (down_right[1] + 1)]
  end

  def free_spaces_down_left(down_left)
    [(down_left[0] + 1), (down_left[1] - 1)]
  end

  def all_free_spaces(piece)
    hv_array = free_spaces_h_V(piece)
    d_array = free_spaces_d(piece)
    hv_array.concat(d_array)
  end




  def move_piece(piece, move_a, free_spaces)
    position = accurate_positions(move_a[0], move_a[1])
    last_position = piece.position
    if piece.move_set(position) && (@board[position[0]][position[1]] == @light_black || @board[position[0]][position[1]] == @light_magenta)
      if free_spaces.any?(position)
        piece.position = piece.update_position(position)
        piece.piece = piece.update_piece
        board = @board
        board[position[0]][position[1]] = piece
        board[last_position[0]][last_position[1]] = last_position[0] % 2 == 0 ? (last_position[1] % 2 == 0 ? "   ".colorize( :background => :light_black)  : "   ".colorize( :background => :light_magenta)) : (last_position[1] % 2 == 0 ? "   ".colorize( :background => :light_magenta)  : "   ".colorize( :background => :light_black))
        update_board(board)
        true
      end
    else
    false
    end
  end

  def attack_piece(piece, move_a, free_spaces)
    position = accurate_positions(move_a[0], move_a[1])
    last_position = piece.position
    if @board[position[0]][position[1]] != @light_black && @board[position[0]][position[1]] != @light_magenta && @board[position[0]][position[1]] != nil
      if @board[position[0]][position[1]].team != piece.team
        if free_spaces.any?(position)
          if piece.attack_set(position) 
            piece.position = piece.update_position(position)
            piece.piece = piece.update_piece
            board = @board
            board[position[0]][position[1]] = piece
            board[last_position[0]][last_position[1]] = last_position[0] % 2 == 0 ? (last_position[1] % 2 == 0 ? "   ".colorize( :background => :light_black)  : "   ".colorize( :background => :light_magenta)) : (last_position[1] % 2 == 0 ? "   ".colorize( :background => :light_magenta)  : "   ".colorize( :background => :light_black))
            update_board(board)
            true
          end
        end
      end
    else
      false
    end
  end

  def knight_move_piece(piece, move_a)
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

  def knight_attack_piece(piece, move_a)
    position = accurate_positions(move_a[0], move_a[1])
    last_position = piece.position
    if @board[position[0]][position[1]] != @light_black && @board[position[0]][position[1]] != @light_magenta && @board[position[0]][position[1]] != nil
      if @board[position[0]][position[1]].team != piece.team
        if piece.attack_set(position) 
          piece.position = piece.update_position(position)
          piece.piece = piece.update_piece
          board = @board
          board[position[0]][position[1]] = piece
          board[last_position[0]][last_position[1]] = last_position[0] % 2 == 0 ? (last_position[1] % 2 == 0 ? "   ".colorize( :background => :light_black)  : "   ".colorize( :background => :light_magenta)) : (last_position[1] % 2 == 0 ? "   ".colorize( :background => :light_magenta)  : "   ".colorize( :background => :light_black))
          update_board(board)
          true
        end
      end
    else
      false
    end
  end

  def move(player)
    puts "#{player}, select piece to move."
    piece = gets.chomp.split('').map(&:to_i)
    position = accurate_positions(piece[0], piece[1])
    toggle = toggle_piece(piece, player)
    free_spaces = all_free_spaces(piece)
    puts 'Select move location.'
    move = gets.chomp.split('').map(&:to_i)
    if @board[position[0]][position[1]].is_a?(Knight)
      if knight_move_piece(toggle, move)
        true
      elsif knight_attack_piece(toggle, move)
        true
      else
        false
      end
    else
      if move_piece(toggle, move, free_spaces)
        true
      elsif attack_piece(toggle, move, free_spaces)
        true
      else
        false
      end
    end
  end
end
