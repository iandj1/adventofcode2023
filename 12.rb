input = File.open("inputs/12-sample.txt")
input = File.open("inputs/12.txt")


def permute_springs(springs, runs)
  # pp springs
  if !(springs.include? '?')
    return runs == calc_runs(springs) ? 1 : 0
  elsif !possible_layout(springs, runs)
    return 0
  end
  str1 = springs.sub('?','.')
  str2 = springs.sub('?','#')
  return permute_springs(str1, runs) + permute_springs(str2, runs)
end

def calc_runs(springs)
  runs = []
  run = 0
  springs = springs + '.'
  springs.chars.each do |spring|
    if spring == '#'
      run += 1
    elsif run != 0
      runs << run
      run = 0
    end
  end
  runs
end

def possible_layout(springs, runs)
  return false if springs.scan(/[#?]+/).map(&:length).max < runs.max # no possible run long enough
  return false if springs.scan(/[#?]*[#][#?]*/).length > runs.length # too many separate runs
  return false if (springs.scan(/[#]+/).map(&:length).max || 0) > runs.max # run too long

  # check if valid from left to right
  spring_split = springs.split('?')
  if spring_split != []
    if spring_split[0].end_with? '.'
      temp_runs = calc_runs(spring_split[0])
      return false if !(runs.take(temp_runs.size) == temp_runs)
    end
  end
  true
end

valid_layouts = 0
input.each_with_index do |line, line_no|
  print "processing line #{line_no}\r"
  line.strip!
  springs, runs = line.split(' ')
  # springs = ([springs]*5).join('?') # part 2
  # runs = ([runs]*5).join(',')
  runs = runs.split(',').map(&:to_i)
  valid_layouts += permute_springs(springs, runs)
end

puts "\nvalid layouts: #{valid_layouts}"
