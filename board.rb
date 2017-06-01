require_relative 'tile'
require 'colorize'

class Board
  def initialize
    @grid = Array.new(9) { Array.new(9) }
    read_file("sudoku1.txt")
  end

  def read_file(file_name)
    tiles = File.readlines(file_name).map(&:chomp).map(&:chars)
    tiles.each.with_index do |row, r_index|
      row.each_index do |c_index|
        value = tiles[r_index][c_index].to_i
        given = value != 0
        @grid[r_index][c_index] = Tile.new(value, given)
      end
    end
  end

  def render
    @grid.each.with_index do |row, r_index|
      row.each_index do |c_index|
        color = @grid[r_index][c_index].given ? :red : :black
        print @grid[r_index][c_index].to_s.colorize(color)
        print "|" if (c_index + 1) % 3 == 0
      end
      print "\n---+---+---+".colorize(:light_black) if (r_index + 1) % 3 == 0
      print "\n"
    end
  end

  def set_value(pos, value)
    row, col = pos

    previous_value = @grid[row][col]

    @grid[row][col] = Tile.new(value)

    if valid?
      puts "That is a valid move"
    else
      puts "That is not a valid move"
      @grid[row][col] = previous_value
    end
  end

  def solved?
    valid? && @grid.flatten.none? { |elem| elem.value == 0 }
  end

  def valid?
    # check all rows
    rows_valid = @grid.all? { |r| no_duplicate?(r) }

    # check all columns
    cols_valid = @grid.transpose.all? { |r| no_duplicate?(r) }

    # check all boxes
    ranges = [(0..2), (3..5), (6..9)]
    boxes = Array.new(9) { [] }
    box_num = 0
    ranges.each do |range|
      rows = @grid[range]
      rows.each do |row|
        boxes[box_num].concat(row[range])
      end
      box_num += 1
    end
    boxes_valid = boxes.all? { |r| no_duplicate?(r) }

    # puts "All rows valid? #{rows_valid}"
    # puts "All cols valid? #{cols_valid}"
    # puts "All boxes valid? #{boxes_valid}"

    rows_valid && cols_valid && boxes_valid
  end

  def no_duplicate?(arr)
    copy = arr.map(&:value)
    copy.delete(0)
    # p copy
    copy.none? { |v| copy.count(v) > 1 }
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @grid[row][col] = value
  end

end
