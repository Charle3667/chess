require 'colorize'
require_relative 'game_board.rb'

class Pawn
  attr_accessor :pawn

  def initialize(y, x)
    @position = [y, x]
    @pawn = @position[0] % 2 == 0 ? (@position[1] % 2 == 0 ? " \u2659 ".colorize( :background => :light_black)  : " \u2659 ".colorize( :background => :light_magenta)) : (@position[1] % 2 == 0 ? " \u2659 ".colorize( :background => :light_magenta)  : " \u2659 ".colorize( :background => :light_black))
  end

  def move_set(move)
    if move == [(@position[0] + 1), @position[1]]
      update_position(move)
      update_pawn(move)
      true
    else
      false
    end
  end

  def update_position(move)
    @position = move
  end

  def update_pawn(move)
    @pawn = @move[1] % 2 == 0 ? (move[0] % 2 == 0 ? " \u2659 ".colorize( :background => :light_black)  : " \u2659 ".colorize( :background => :light_magenta)) : (move[0] % 2 == 0 ? " \u2659 ".colorize( :background => :light_magenta)  : " \u2659 ".colorize( :background => :light_black))
  end
end

# comment