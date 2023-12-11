input = File.open("inputs/10-sample.txt")
input = File.open("inputs/10.txt")

class Pipe
  @@pipes = {}

  attr_accessor :tile

  def initialize(tile, row, column)
    @row = row
    @column = column
    coord = [row, column]
    @tile = tile
    @@pipes[coord] = self
  end

  def coord
    [@row, @column]
  end

  def to_s
    "#{@tile} @ #{@row}, #{@column}"
  end

  def connected_pipes
    adjacent_coords = []

    if @tile == 'S'
      connected_pipes = []
      adjacent_coords = {
        [@row-1, @column] => 'left',
        [@row+1, @column] => 'right',
        [@row, @column-1] => 'up',
        [@row, @column+1] => 'down'
      }
      connected_dirs = []
      adjacent_coords.each do |coord, direction|
        adj_pipe = @@pipes[coord]
        next if adj_pipe.nil?
        connected_dirs << direction
        connected_pipes << adj_pipe if adj_pipe.connected_pipes.include? self
      end
      # janky solution to replacing the S character for part 2
      if connected_dirs.include? 'down'
        connected_dirs.delete('down')
        if ['left', 'up', 'right'].include? connected_dirs.first
          @tile = 's'
        end
      end
      return connected_pipes
    end

    adjacent_coords << [@row - 1, @column] if ['|', 'L', 'J'].include?(@tile)
    adjacent_coords << [@row + 1, @column] if ['|', '7', 'F'].include?(@tile)
    adjacent_coords << [@row, @column - 1] if ['-', 'J', '7'].include?(@tile)
    adjacent_coords << [@row, @column + 1] if ['-', 'F', 'L'].include?(@tile)
    adjacent_coords.select{|coord| @@pipes.has_key? coord}.map{|coord| @@pipes[coord]}
  end

  def next_pipe(prev=nil)
    connected = self.connected_pipes
    connected.delete(prev)
    connected.first
  end

  def follow_loop(path = [])
    return path if path.first == self
    prev = path.empty? ? nil : path.last
    next_pipe = next_pipe(prev)
    next_pipe.follow_loop(path << self)
  end
end

start = nil
input.each_with_index do |line, row|
  line.strip.chars.each_with_index do |tile, column|
    if tile != '.'
      pipe = Pipe.new(tile, row, column)
      start = pipe if tile == 'S'
    end
  end
end

path = start.follow_loop
puts "part 1: #{path.length / 2}"

path_h = path.map{|pipe| [pipe.coord, pipe]}.to_h

path_coords = path.map(&:coord)
rows = path_coords.map(&:first)
cols = path_coords.map(&:last)
row_min = rows.min
row_max = rows.max
col_min = cols.min
col_max = cols.max

n_inside = 0
(row_min..row_max).each do |row|
  inside = false
  (col_min..col_max).each do |col|
    pipe = path_h[[row, col]]
    inside = !inside if ['|', 'F', '7', 's'].include? pipe&.tile
    if inside && pipe.nil?
      n_inside += 1
    end
  end
end

puts "part 2: #{n_inside}"
