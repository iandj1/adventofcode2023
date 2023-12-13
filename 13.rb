input = File.open("inputs/13-sample.txt")
input = File.open("inputs/13.txt")

grids = []

# parse input
grid = []
input.each do |line|
  line.strip!
  if line == ''
    grids << grid
    grid = []
  else
    grid << line.chars
  end
end
grids << grid


def find_rocks(grid)
  row_hash = {}
  col_hash = {}
  grid.each_with_index do |grid_row, row|
    grid_row.each_with_index do |char, col|
      if char == '#'
        row_hash[row] ||= Set.new
        row_hash[row] << col
        col_hash[col] ||= Set.new
        col_hash[col] << row
      end
    end
  end
  return row_hash, col_hash
end

def find_reflection(grid_hash, n_smudges)
  n_rows = grid_hash.count
  (1...n_rows).each do |reflection_row|
    rows_to_check = [reflection_row, n_rows-reflection_row].min
    diff = 0
    (1..rows_to_check).each do |offset|
      diff += (grid_hash[reflection_row - offset] ^ grid_hash[reflection_row + offset - 1]).count
      break if diff > n_smudges
    end
    return reflection_row if diff == n_smudges
  end
  nil
end

sum1 = 0
sum2 = 0
grids.each do |grid|
  row_hash, col_hash = find_rocks(grid)
  n = find_reflection(col_hash, 0)
  n = find_reflection(row_hash, 0)*100 if n.nil?
  sum1 += n

  n = find_reflection(col_hash, 1)
  n = find_reflection(row_hash, 1)*100 if n.nil?
  sum2 += n
end

puts "part 1: #{sum1}"
puts "part 2: #{sum2}"