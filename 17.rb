input = File.open("inputs/17-sample.txt")
input = File.open("inputs/17.txt")

grid = []
input.each_with_index do |line, row|
  line.strip!
  grid[row] = []
  line.chars.each_with_index do |char, col|
    grid[row][col] = char.to_i
  end
end

new_nodes = [[0,0,:none,0]]
min_grid = {new_nodes[0] => 0} # [row, col, direction, distance] => total

size = grid.length

directions = {north: [-1,0], south: [1,0], west: [0,-1], east: [0,1]}
bad_directions = [[:north, :south], [:east, :west]] # can't do 180 turn

while !new_nodes.empty?
  next_nodes = []
  new_nodes.each do |row, col, direction, distance|
    current_total = min_grid[[row, col, direction, distance]]
    directions.each do |new_dir, delta_coord|
      next if bad_directions.include? [direction, new_dir].sort # skip 180 degree turns
      if new_dir == direction
        new_distance = distance + 1
      else
        new_distance = 1
      end
      next if new_distance > 3 # can't go too far in straight line
      new_row = row + delta_coord[0]
      new_col = col + delta_coord[1]
      next if [-1, size].include?(new_row) || [-1, size].include?(new_col) # out of bound check
      key = [new_row, new_col, new_dir, new_distance]
      current_min = min_grid[key]
      if current_min.nil? || (current_min && (current_total + grid[new_row][new_col] < current_min))
        min_grid[key] = current_total + grid[new_row][new_col]
        next_nodes << key
      end
    end
    new_nodes = next_nodes
  end
end

min = Float::MAX
[:east, :south].product([1,2,3]).each do |dir_pair|
  key = [size-1, size-1] + dir_pair
  min = [min, min_grid[key]].min
end

puts "part 1: #{min}"