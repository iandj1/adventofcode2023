input = File.open("inputs/3-sample.txt")
input = File.open("inputs/3.txt")

symbols = Set.new # [x,y]
stars = {} # [x,y] => Set(number_arrays)
numbers = [] # [int, [[x,y], [x,y]]]

# process input
input.each_with_index do |line, y|
  line = line.strip + '.' # easiest way to deal with numbers ending in last column
  number = ''
  coords = []
  line.each_char.with_index do |char, x|
    if char =~ /[0-9]/
      number += char
      coords << [x,y]
    else
      if number != ''
        numbers << [number.to_i, coords]
        number = ''
        coords = []
      end
      next if char == '.'
      symbols << [x,y]
      stars[[x,y]] = Set.new if char == '*'
    end
  end
end

# check numbers and symbols
sum = 0
numbers.each do |number_a|
  number, coords = number_a
  coords.each do |coord|
    x, y = coord
    adjacent_coords = [x-1,x,x+1].product([y-1,y,y+1])
    if adjacent_coords.any?{|coord| symbols.include?(coord)}
      sum += number
      break
    end
  end
end

puts sum

# part 2
numbers.each do |number_a|
  number, coords = number_a
  coords.each do |coord|
    x, y = coord
    adjacent_coords = [x-1,x,x+1].product([y-1,y,y+1])
    adjacent_coords.each do |adj_coord|
      if stars.include? adj_coord
        stars[adj_coord] << number_a
      end
    end
  end
end

sum = 0
stars.each do |star, numbers_set|
  next unless numbers_set.size == 2
  numbers_a = numbers_set.to_a
  sum += numbers_a[0][0] * numbers_a[1][0]
end

puts sum