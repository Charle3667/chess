require 'colorize'
require 'json'
require_relative 'pawn.rb'
require_relative 'king.rb'
require_relative 'knight.rb'
require_relative 'rooke.rb'
require_relative 'bishop.rb'
require_relative 'queen.rb'

class GameBoard
  attr_accessor :player_one, :player_two, :game_over, :turn

  def initialize(player_one = 'Player One', player_two = 'Player Two')
    @turn = 0
    @white_check = false
    @black_check = false
    @checkmate = false
    @game_over = false
    # white
    @player_one = player_one
    # black
    @player_two = player_two
    @light_black = '   '.colorize( :background => :light_black)
    @light_magenta = '   '.colorize( :background => :light_magenta)
    @board = Array.new(8) { |i| i % 2 == 0 ? Array.new(8) {|i| i % 2 == 0 ? '   '.colorize( :background => :light_black) : '   '.colorize( :background => :light_magenta)} : Array.new(8) {|i| i % 2 == 0 ? '   '.colorize( :background => :light_magenta) : '   '.colorize( :background => :light_black)} }
  end

  def next_turn
    @turn += 1
  end

  def create_board_array
    board_array = []
    for array in @board
      for slot in array
        if slot.is_a?(Queen) || slot.is_a?(Rooke) || slot.is_a?(Knight) || slot.is_a?(Bishop) || slot.is_a?(Pawn) || slot.is_a?(King)
          board_array.push([slot.class, slot.team, slot.position])
        end
      end
    end
    board_array
  end

  def create_json
    board = create_board_array
    JSON.dump ({
      board: board,
      player_one: @player_one,
      player_two: @player_two,
      turn: @turn
    })
  end

  def save_game
    data = create_json
    puts 'What would you like to name your saved game?'
    id = gets.strip
    Dir.mkdir('saved_games') unless Dir.exist?('saved_games')
    filename = "saved_games/save_#{id}.txt"
    File.open(filename, 'w') do |file|
      file.puts data
    end
    puts "Game has been saved as 'saved_games/save_#{id}.txt'."
  end

  def load_a_save?
    save = choose_save_game
    load_from_json(save)
    display_board
    puts 'Game loaded.'
  end

  def choose_save_game
    puts 'Which game would you like to load?'
    puts Dir.entries('saved_games')
    answer = gets.strip
    puts "saved_games/#{answer}"
    if File.exist?("saved_games/#{answer}")
      file = File.open("saved_games/#{answer}", 'r')
      contents = file.read
    else
      puts 'File does not exits.'
    end
  end

  def load_from_json(save)
    data = JSON.parse(save)
    board_array = data['board']
    set_saved_board(board_array)
    @player_one = data['player_one']
    @player_two = data['player_two']
    @turn = data['turn']
  end

  def set_saved_board(board_array)
    for piece in board_array
      y = piece[2][0]
      x = piece[2][1]
      team = piece[1]
      if piece[0] == "Rooke"
        @board[y][x] = Rooke.new(y, x, team)
      elsif piece[0] == "Knight"
        @board[y][x] = Knight.new(y, x, team)
      elsif piece[0] == "Bishop"
        @board[y][x] = Bishop.new(y, x, team)
      elsif piece[0] == "King"
        @board[y][x] = King.new(y, x, team)
      elsif piece[0] == "Queen"
        @board[y][x] = Queen.new(y, x, team)
      elsif piece[0] == "Pawn"
        @board[y][x] = Pawn.new(y, x, team)
      end
    end
  end

  def display_board(board = @board)
    it = 9
    for array in board
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

  def inaccurate_positions(y, x)
    array = (1..8).to_a.reverse
    i = array[y]
    [(x + 1), i]
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
        false
      end
    else
      if @board[position[0]][position[1]].team == 'black'
        @board[position[0]][position[1]]
      else
        puts 'Not your piece'
        false
      end
    end
  end

  def valid_piece(player)
    correct_piece = false
    until correct_piece == true
      puts "#{player}, select piece to move. Or press 's' to save and quit."
      s_piece = gets.chomp
      piece = s_piece.split('').map(&:to_i)
      if s_piece == 'q'
        @game_over = true
        break
      elsif s_piece == 's'
        save_game
        @game_over = true
        break
      elsif piece == [] || piece[0] > 8 || piece[1] > 8
        puts 'Not a piece'
      elsif toggle_piece(piece, player)
        correct_piece = true
      end
    end
    piece
  end

  def free_spaces_h_V(piece)
    # position = accurate_positions(piece[0], piece[1])
    position = piece
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
    # position = accurate_positions(piece[0], piece[1])
    position = piece
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
    check_checker(player)
    if @checkmate
      @game_over = true
      puts "Checkmate!"
      return
    end
    toggle = nil
    piece = valid_piece(player)
    if @game_over == true
      return
    else
      toggle = toggle_piece(piece, player)
      position = accurate_positions(piece[0], piece[1])
      free_spaces = all_free_spaces(accurate_positions(piece[0], piece[1]))
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
          premote_pawn(move)
          true
        elsif attack_piece(toggle, move, free_spaces)
          premote_pawn(move)
          true
        else
          false
        end
      end
    end
  end

  def premote_pawn(move)
    position = accurate_positions(move[0], move[1])
    valid_selection = false
    if @board[position[0]][position[1]].is_a?(Pawn)
      if @board[position[0]][position[1]].team == 'white'
        if position[0].zero?
          until valid_selection == true
            puts 'Please enter the first letter of the piece you would like to promote the pawn to.'
            new_piece = gets.chomp
            if new_piece == 'q'
              valid_selection = true
              @board[position[0]][position[1]] = Queen.new(position[0], position[1], 'white')
            elsif new_piece == 'r'
              valid_selection = true
              @board[position[0]][position[1]] = Rooke.new(position[0], position[1], 'white')
            elsif new_piece == 'k'
              valid_selection = true
              @board[position[0]][position[1]] = Knight.new(position[0], position[1], 'white')
            elsif new_piece == 'b'
              valid_selection = true
              @board[position[0]][position[1]] = Bishop.new(position[0], position[1], 'white')
            else
              puts 'Not a valid selection.'
            end
          end
        end
      else
        if position[0] == 7
          until valid_selection == true
            puts 'Please enter the first letter of the piece you would like to promote the pawn to.'
            new_piece = gets.chomp
            if new_piece == 'q'
              valid_selection = true
              @board[position[0]][position[1]] = Queen.new(position[0], position[1], 'black')
            elsif new_piece == 'r'
              valid_selection = true
              @board[position[0]][position[1]] = Rooke.new(position[0], position[1], 'black')
            elsif new_piece == 'k'
              valid_selection = true
              @board[position[0]][position[1]] = Knight.new(position[0], position[1], 'black')
            elsif new_piece == 'b'
              valid_selection = true
              @board[position[0]][position[1]] = Bishop.new(position[0], position[1], 'black')
            else
              puts 'Not a valid selection.'
            end
          end
        end
      end
    end
  end

  def check_checker(player)
    if player == @player_one
      is_check('white')
      if @white_check == true
        puts 'White King is in Check'
        is_checkmate('white')
      end
    else
      is_check('black')
      if @black_check == true
        puts 'Black King is in Check'
        is_checkmate('black')
      end
    end
  end

  def is_check(team, board = @board)
    king_position = king_finder(team)
    if team == 'white'
      @white_check = false
      for array in board 
        for slot in array
          if slot.is_a?(Queen) || slot.is_a?(Rooke) || slot.is_a?(Knight) || slot.is_a?(Bishop) || slot.is_a?(Pawn)
            if slot.team == 'black'
              free_spaces = all_free_spaces(slot.position)
              if free_spaces.any?(king_position)
                if slot.attack_set(king_position)
                  @white_check = true
                end
              end
            end
          elsif slot.is_a?(Knight)
            if slot.team == 'black'
              if slot.attack_set(king_position)
                @white_check = true
              end
            end
          end
        end
      end
    else
      @black_check = false
      for array in board 
        for slot in array
          if slot.is_a?(Queen) || slot.is_a?(Rooke) || slot.is_a?(Bishop) || slot.is_a?(Pawn)
            if slot.team == 'white'
              free_spaces = all_free_spaces(slot.position)
              if free_spaces.any?(king_position)
                if slot.attack_set(king_position)
                  @black_check = true
                end
              end
            end
          elsif slot.is_a?(Knight)
            if slot.team == 'white'
              if slot.attack_set(king_position)
                @black_check = true
              end
            end
          end
        end
      end
    end
  end

  def king_finder(team)
    if team == 'white'
      for array in @board
        for slot in array
          if slot.is_a?(King)
            if slot.team == 'white'
              return slot.position
              # returns [y, x]
            end
          end
        end
      end
    else
      for array in @board
        for slot in array
          if slot.is_a?(King)
            if slot.team == 'black'
              return slot.position
              # returns [y, x]
            end
          end
        end
      end
    end
  end

  def is_checkmate(team)
    the_board = @board
    checkmate = true
    for array in the_board
      for slot in array
        if slot.is_a?(Queen) || slot.is_a?(Rooke) || slot.is_a?(Knight) || slot.is_a?(Bishop) || slot.is_a?(Pawn) || slot.is_a?(King)
          if slot.team == team
            unless check_all_moves(slot, team)
              checkmate = false
            end
          end
        end
      end
    end
    @checkmate = true if checkmate == true
  end

  def check_all_moves(slot, team)
    og = slot.position
    first_position = inaccurate_positions(og[0], og[1])
    check = true
    (1..8).each do |x|
      (1..8).each do |y|
        move = accurate_positions(x, y)
        new_slot = @board[move[0]][move[1]]
        if move_tester(slot, x, y)
          unless is_check_test(team)
            check = false
          end
          undo_move_tester(slot, first_position[0], first_position[1], new_slot)
        end
      end
    end
    check
  end

  def move_tester(toggle, x, y)
    move = [x, y]
    free_spaces = all_free_spaces(toggle.position)
    if @board[toggle.position[0]][toggle.position[1]].is_a?(Knight)
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

  def undo_move_tester(toggle, x, y, new_slot)
    move = [x, y]
    old_position = toggle.position
    free_spaces = all_free_spaces(toggle.position)
    if @board[toggle.position[0]][toggle.position[1]].is_a?(Knight)
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
    @board[old_position[0]][old_position[1]] = new_slot
  end

  def is_check_test(team, board = @board)
    king_position = king_finder(team)
    check = false
    if team == 'white'
      for array in board 
        for slot in array
          if slot.is_a?(Queen) || slot.is_a?(Rooke) || slot.is_a?(Knight) || slot.is_a?(Bishop) || slot.is_a?(Pawn)
            if slot.team == 'black'
              free_spaces = all_free_spaces(slot.position)
              if free_spaces.any?(king_position)
                if slot.attack_set(king_position)
                  check = true
                end
              end
            end
          elsif slot.is_a?(Knight)
            if slot.team == 'black'
              if slot.attack_set(king_position)
                check = true
              end
            end
          end
        end
      end
    else
      @black_check = false
      for array in board 
        for slot in array
          if slot.is_a?(Queen) || slot.is_a?(Rooke) || slot.is_a?(Bishop) || slot.is_a?(Pawn)
            if slot.team == 'white'
              free_spaces = all_free_spaces(slot.position)
              if free_spaces.any?(king_position)
                if slot.attack_set(king_position)
                  check = true
                end
              end
            end
          elsif slot.is_a?(Knight)
            if slot.team == 'white'
              if slot.attack_set(king_position)
                check = true
              end
            end
          end
        end
      end
    end
    check
  end
  
end

# the land of lost code

# def is_checkmate(team)
#   the_board = @board
#   for array in the_board
#     for slot in array
#       if slot.is_a?(Queen) || slot.is_a?(Rooke) || slot.is_a?(Knight) || slot.is_a?(Bishop) || slot.is_a?(Pawn) || slot.is_a?(King)
#         if slot.team == team
#           @checkmate = true if check_all_moves(slot, team, the_board)
#         end
#       end
#     end
#   end
# end

# def check_all_moves(slot, team, the_board)
#   check = true
#   if slot.is_a?(Knight)
#     the_board.each_with_index do |array, y|
#       array.each_with_index do |piece, x|
#         if slot.return_possible_moves.any?([x, y])
#           last_position = slot.position
#           new_board = the_board
#           new_board[y][x] = slot
#           new_board[last_position[0]][last_position[1]] = last_position[0] % 2 == 0 ? (last_position[1] % 2 == 0 ? "   ".colorize( :background => :light_black)  : "   ".colorize( :background => :light_magenta)) : (last_position[1] % 2 == 0 ? "   ".colorize( :background => :light_magenta)  : "   ".colorize( :background => :light_black))
#           if is_check_bool(team, new_board) == false
#             check = false
#             break
#           end
#         end
#       end
#     end
#   else
#     free_spaces = all_free_spaces(slot.position)
#     the_board.each_with_index do |array, y|
#       array.each_with_index do |piece, x|
#         if free_spaces.any?([x, y])
#           if slot.return_possible_moves.any?([x, y])
#             last_position = slot.position
#             new_board = the_board
#             new_board[y][x] = slot
#             new_board[last_position[0]][last_position[1]] = last_position[0] % 2 == 0 ? (last_position[1] % 2 == 0 ? "   ".colorize( :background => :light_black)  : "   ".colorize( :background => :light_magenta)) : (last_position[1] % 2 == 0 ? "   ".colorize( :background => :light_magenta)  : "   ".colorize( :background => :light_black))
#             if is_check_bool(team, new_board) == false
#               check = false
#               break
#             end
#           end
#         end
#       end
#     end
#   end
#   check
# end

# def is_check_bool(team, new_board)
#   king_position = king_finder(team)
#   check = false
#   if team == 'white'
#     for array in new_board 
#       for slot in array
#         if slot.is_a?(Queen) || slot.is_a?(Rooke) || slot.is_a?(Knight) || slot.is_a?(Bishop) || slot.is_a?(Pawn)
#           if slot.team == 'black'
#             free_spaces = all_free_spaces(slot.position)
#             if free_spaces.any?(king_position)
#               if slot.attack_set(king_position)
#                 check = true
#               end
#             end
#           end
#         end
#       end
#     end
#   else
#     for array in new_board 
#       for slot in array
#         if slot.is_a?(Queen) || slot.is_a?(Rooke) || slot.is_a?(Knight) || slot.is_a?(Bishop) || slot.is_a?(Pawn)
#           if slot.team == 'white'
#             free_spaces = all_free_spaces(slot.position)
#             if free_spaces.any?(king_position)
#               if slot.attack_set(king_position)
#                 check = true
#               end
#             end
#           end
#         end
#       end
#     end
#   end
#   check
# end


# def is_check(piece)
#   position = accurate_positions(piece[0], piece[1])
#   piece = @board[position[0]][position[1]]
#   p "piece is #{piece.piece}"
#   if piece.team == 'white'
#     p "piece is white"
#     king_position = king_finder('black')
#     p "Black king position is #{king_position}"
#     if piece.attack_set(king_position)
#       p 'black_check is true'
#       @black_check = true
#     end
#   end
#   if piece.team == 'black'
#     p "piece is black"
#     king_position = king_finder('white')
#     p "White king position is #{king_position}"
#     if piece.attack_set(king_position)
#       p 'white_check is true'
#       @white_check = true
#     end
#   end
# end ee

 