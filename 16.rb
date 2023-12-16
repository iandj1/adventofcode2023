input = File.open("inputs/16-sample.txt")
input = File.open("inputs/16.txt")

mirrors = {}
splitters = {}

row_max = 0
col_max = 0
input.each_with_index do |line, row|
  row_max = [row_max, row].max
  line.strip!
  line.chars.each_with_index do |char, col|
    coord = [row, col]
    col_max = [col_max, col].max
    if char.match? /[\/\\]/
      mirrors[coord] = char
    elsif char.match? /[|-]/
      splitters[coord] = char
    end
  end
end

def do_beam(row, col, direction, beams, mirrors, splitters, row_max, col_max)
  return if row < 0 || row > row_max || col < 0 || col > col_max
  coord = [row, col]
  # already processed this beam?
  return unless beams.add? [coord, direction]
  # mirrors
  mirror = mirrors[coord]
  if mirror == '/'
    case direction
    when 'up'
      do_beam(row, col+1, 'right', beams, mirrors, splitters, row_max, col_max)
    when 'down'
      do_beam(row, col-1, 'left', beams, mirrors, splitters, row_max, col_max)
    when 'left'
      do_beam(row+1, col, 'down', beams, mirrors, splitters, row_max, col_max)
    when 'right'
      do_beam(row-1, col, 'up', beams, mirrors, splitters, row_max, col_max)
    end
    return
  elsif mirror == '\\'
    case direction
    when 'up'
      do_beam(row, col-1, 'left', beams, mirrors, splitters, row_max, col_max)
    when 'down'
      do_beam(row, col+1, 'right', beams, mirrors, splitters, row_max, col_max)
    when 'left'
      do_beam(row-1, col, 'up', beams, mirrors, splitters, row_max, col_max)
    when 'right'
      do_beam(row+1, col, 'down', beams, mirrors, splitters, row_max, col_max)
    end
    return
  end
  # splitters
  splitter = splitters[coord]
  if splitter == '|' && ['left', 'right'].include?(direction)
    do_beam(row-1, col, 'up', beams, mirrors, splitters, row_max, col_max)
    do_beam(row+1, col, 'down', beams, mirrors, splitters, row_max, col_max)
    return
  elsif splitter == '-' && ['up', 'down'].include?(direction)
    do_beam(row, col-1, 'left', beams, mirrors, splitters, row_max, col_max)
    do_beam(row, col+1, 'right', beams, mirrors, splitters, row_max, col_max)
    return
  end
  # blank space
  case direction
  when 'up'
    do_beam(row-1, col, direction, beams, mirrors, splitters, row_max, col_max)
  when 'down'
    do_beam(row+1, col, direction, beams, mirrors, splitters, row_max, col_max)
  when 'left'
    do_beam(row, col-1, direction, beams, mirrors, splitters, row_max, col_max)
  when 'right'
    do_beam(row, col+1, direction, beams, mirrors, splitters, row_max, col_max)
  end
end

beams = Set.new # [row, col, direction]
do_beam(0, 0, 'right', beams, mirrors, splitters, row_max, col_max)
puts "part 1: #{beams.map(&:first).uniq.count}"

max = 0
(0..col_max).each do |col|
  beams = Set.new
  do_beam(0, col, 'down', beams, mirrors, splitters, row_max, col_max)
  max = [max, beams.map(&:first).uniq.count].max
  beams = Set.new
  do_beam(row_max, col, 'up', beams, mirrors, splitters, row_max, col_max)
  max = [max, beams.map(&:first).uniq.count].max
end
# just in case input isn't square...
(0..row_max).each do |row|
  beams = Set.new
  do_beam(row, 0, 'right', beams, mirrors, splitters, row_max, col_max)
  max = [max, beams.map(&:first).uniq.count].max
  beams = Set.new
  do_beam(row, col_max, 'left', beams, mirrors, splitters, row_max, col_max)
  max = [max, beams.map(&:first).uniq.count].max
end

puts "part 2: #{max}"