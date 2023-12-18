input = File.open("inputs/18-sample.txt")
# input = File.open("inputs/18.txt")

coord = [0,0]
dir_lookup = {
  '3' => [-1, 0],
  '1' => [1, 0],
  '2' => [0, -1],
  '0' => [0, 1],
}

horizontal_ranges = []
vertical_ranges = []
interesting_rows = []

# parse input
input.each_with_index do |line, index|
  # puts index
  line.strip!
  hex = line.split('#')[1].chomp(')')
  dist = Integer('0x' + hex.slice(0,5))
  dir = hex[-1]

  start_coord = coord

  delta_coord  = dir_lookup[dir]
  if delta_coord[0] != 0 # vertical line
    coord = [coord[0] + delta_coord[0] * dist, coord[1]]
    if coord[0] > start_coord[0]
      vertical_ranges << [(start_coord[0]..coord[0]), coord[1]]
    else
      vertical_ranges << [(coord[0]..start_coord[0]), coord[1]]
    end
    interesting_rows.concat([start_coord[0]])
  else # horizontal line
    coord = [coord[0], delta_coord[1] * dist + coord[1]]
    if coord[1] > start_coord[1]
      horizontal_ranges << [coord[0], (start_coord[1]..coord[1])]
    else
      horizontal_ranges << [coord[0], (coord[1]..start_coord[1])]
    end
  end
end
interesting_rows.sort!

pp horizontal_ranges
pp vertical_ranges

pp interesting_rows

sum = 0
interesting_rows.each do |interesting_row|
  # add holes in this row

  # add holes in following row * length of next run
  # skip this if interesting_row == interesting_rows[-1]
end

puts "part 2: #{sum}"

puts interesting_rows.count
