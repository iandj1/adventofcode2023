input = File.open("inputs/18-sample.txt")
input = File.open("inputs/18.txt")

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
interesting_rows.sort!.uniq!

def row_total(horizontal_ranges, vertical_ranges, row)
  relevant_horizontals = horizontal_ranges.select{|h_range| h_range[0] == row}.map(&:last).sort_by{|range| range.first}
  intersecting_verticals = vertical_ranges.select{|v_range| v_range[0].cover?(row) && !([v_range[0].first, v_range[0].last].include?(row))}.map(&:last).sort
  row_sum = 0

  inside = false
  start = nil
  while !relevant_horizontals.empty? || !intersecting_verticals.empty?
    if relevant_horizontals.empty? || (!intersecting_verticals.empty? && intersecting_verticals.first < relevant_horizontals.first.first) # crossing vertical wall
      if inside
        row_sum += (intersecting_verticals.shift - start + 1)
      else
        start = intersecting_verticals.shift
      end
      inside = !inside
    else # passing through horizontal wall
      h_range = relevant_horizontals.shift
      start_dir = vertical_ranges.select{|v_range| v_range[0].first == row && v_range[1] == h_range.first}.empty? ? :up : :down
      end_dir = vertical_ranges.select{|v_range| v_range[0].first == row && v_range[1] == h_range.last}.empty? ? :up : :down
      if start_dir != end_dir
        if inside
          row_sum += (h_range.first - start)
        else
          start = h_range.last + 1
        end
        row_sum += h_range.size
        inside = !inside
      else
        row_sum += h_range.size if !inside
      end
    end
  end
  row_sum
end

sum = 0
while !interesting_rows.empty?
  row = interesting_rows.shift

  # add holes in this row
  row_total = row_total(horizontal_ranges, vertical_ranges, row)
  sum += row_total

  # add holes in following row * length of next run
  next_interesting_row = interesting_rows[0]
  next_row = row + 1
  break if next_interesting_row.nil? # skip this if we're on the last row
  next if next_row == next_interesting_row # also skip if next row is also interesting
  next_row_total = row_total(horizontal_ranges, vertical_ranges, next_row)
  sum += (next_row_total * (next_interesting_row - next_row))
end

puts "part 2: #{sum}"