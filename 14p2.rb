input = File.open("inputs/14-sample.txt")
input = File.open("inputs/14.txt")

rocks = Set.new
cubes = Set.new
row_max = 0
col_max = 0

input.each_with_index do |line, row|
  line.strip!
  row_max = [row_max, row].max
  line.chars.each_with_index do |char, col|
    col_max = [col_max, col].max
    if char == '#'
      cubes << [row, col]
    elsif char == 'O'
      rocks << [row, col]
    end
  end
end

def roll_rocks(rocks, cubes, direction, row_max, col_max)
  loop do
    moved = false
    rocks.to_a.each do |rock|
      test_coord = [rock[0] + direction[0], rock[1] + direction [1]]
      next if test_coord[0] < 0 || test_coord[0] > row_max
      next if test_coord[1] < 0 || test_coord[1] > col_max
      next if rocks.include? test_coord
      next if cubes.include? test_coord
      rocks.delete(rock)
      rocks << test_coord
      moved = true
    end
    break if !moved
  end
end

states = {}

loop.with_index do |_, index|
  roll_rocks(rocks, cubes, [-1, 0], row_max, col_max)
  roll_rocks(rocks, cubes, [0, -1], row_max, col_max)
  roll_rocks(rocks, cubes, [1, 0], row_max, col_max)
  roll_rocks(rocks, cubes, [0, 1], row_max, col_max)
  if states[rocks]
    cycle = index - states[rocks]
    puts "#{index} is same as #{states[rocks]} with cycle of #{cycle}"
    break if (1000000000 - (index+1)) % cycle == 0
  end
  states[rocks] = index
end

sum = 0
rocks.each do |rock|
  sum += row_max - rock[0] + 1
end

puts "part 2: #{sum}"
