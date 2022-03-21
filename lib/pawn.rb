require 'colorize'
require_relative 'game_board.rb'

class Pawn
  attr_accessor :piece, :position, :team

  def initialize(y, x)
    @team = 'white'
    @base = [y,x]
    @position = [y, x]
    @piece = @position[0] % 2 == 0 ? (@position[1] % 2 == 0 ? " \u2659 ".colorize( :background => :light_black)  : " \u2659 ".colorize( :background => :light_magenta)) : (@position[1] % 2 == 0 ? " \u2659 ".colorize( :background => :light_magenta)  : " \u2659 ".colorize( :background => :light_black))
  end

  def move_set(move)
    possible_move_one = [(@position[0] - 1), @position[1]]
    possible_move_two = [(@position[0] - 2), @position[1]]
    if @position == @base
      if move == possible_move_one || move == possible_move_two
        true
      else
        false
      end
    else
      if move == possible_move_one
        true
      else
        false
      end
    end
  end

  def attack_set(move)
    possible_move_one = [(@position[0] - 1), (@position[1] - 1)]
    possible_move_two = [(@position[0] - 1), (@position[1] + 1)]
    if move == possible_move_one || move == possible_move_two
      true
    else
      false
    end
  end

  def update_position(move)
    @position = move
  end

  def update_piece
    @peice = @position[0] % 2 == 0 ? (@position[1] % 2 == 0 ? " \u2659 ".colorize( :background => :light_black)  : " \u2659 ".colorize( :background => :light_magenta)) : (@position[1] % 2 == 0 ? " \u2659 ".colorize( :background => :light_magenta)  : " \u2659 ".colorize( :background => :light_black))
  end
end

# comment