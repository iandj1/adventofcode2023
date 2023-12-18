input = File.open("inputs/18-sample.txt")
input = File.open("inputs/18.txt")

holes = Set.new
coord = [0,0]
dir_lookup = {
  'U' => [-1, 0],
  'D' => [1, 0],
  'L' => [0, -1],
  'R' => [0, 1],
}

# parse input
input.each do |line|
  line.strip!
  dir, dist, colour = line.split(' ')
  dist = dist.to_i
  delta_coord  = dir_lookup[dir]
  dist.times do
    coord = [coord[0] + delta_coord[0], coord[1] + delta_coord[1]]
    holes << coord
  end
end

min_row = holes.map(&:first).min
max_row = holes.map(&:first).max
min_col = holes.map(&:last).min
max_col = holes.map(&:last).max

fill_holes = Set.new

(min_row..max_row).each do |row|
  inside = false
  prev = false
  (min_col..max_col).each do |col|
    if holes.include?([row, col]) && !holes.include?([row, col-1])
      inside = !inside
    end
    fill_holes << [row, col] if inside
  end
end

pp (holes+fill_holes).size
