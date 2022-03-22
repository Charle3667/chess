require 'colorize'
require_relative 'game_board.rb'

class Rooke
  attr_accessor :piece, :position, :team

  def initialize(y, x, team)
    @team = team
    @base = [y,x]
    @position = [y, x]
    if team == 'white'
      @piece = @position[0] % 2 == 0 ? (@position[1] % 2 == 0 ? " \u2656 ".colorize( :background => :light_black)  : " \u2656 ".colorize( :background => :light_magenta)) : (@position[1] % 2 == 0 ? " \u2656 ".colorize( :background => :light_magenta)  : " \u2656 ".colorize( :background => :light_black))
    else
      @piece = @position[0] % 2 == 0 ? (@position[1] % 2 == 0 ? " \u265C ".colorize( :color => :black, :background => :light_black)  : " \u265C ".colorize( :color => :black, :background => :light_magenta)) : (@position[1] % 2 == 0 ? " \u265C ".colorize( :color => :black, :background => :light_magenta)  : " \u265C ".colorize( :color => :black, :background => :light_black))
    end
  end

  def return_possible_moves
    array = []
    right = @position
    left = @position
    up = @position
    down = @position
    until right[1] > 6
      right = [right[0], (right[1] + 1)]
      array.push(right)
    end
    until left[1] < 1
      left = [left[0], (left[1] - 1)]
      array.push(left)
    end
    until up[0] < 1
      up = [(up[0] -1), (up[1])]
      array.push(up)
    end
    until down[0] > 6
      down = [(down[0] + 1), (down[1])]
      array.push(down)
    end
    array
  end

  def move_set(move)
    possible_moves = return_possible_moves
    if possible_moves.any?(move)
      true
    else
      false
    end
  end

  def attack_set(move)
    possible_moves = return_possible_moves
    if possible_moves.any?(move)
      true
    else
      false
    end
  end

  def update_position(move)
    @position = move
  end

  def update_piece
    if team == 'white'
      @piece = @position[0] % 2 == 0 ? (@position[1] % 2 == 0 ? " \u2656 ".colorize( :background => :light_black)  : " \u2656 ".colorize( :background => :light_magenta)) : (@position[1] % 2 == 0 ? " \u2656 ".colorize( :background => :light_magenta)  : " \u2656 ".colorize( :background => :light_black))
    else
      @piece = @position[0] % 2 == 0 ? (@position[1] % 2 == 0 ? " \u265C ".colorize( :color => :black, :background => :light_black)  : " \u265C ".colorize( :color => :black, :background => :light_magenta)) : (@position[1] % 2 == 0 ? " \u265C ".colorize( :color => :black, :background => :light_magenta)  : " \u265C ".colorize( :color => :black, :background => :light_black))
    end
  end
end