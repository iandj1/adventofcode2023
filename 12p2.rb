input = File.open("inputs/12-sample.txt")
input = File.open("inputs/12.txt")


def permute_springs(springs, runs, cache)
  springs.gsub!(/[.]+/, '.')
  springs.gsub!(/^[.]+/, '')
  result = cache[[springs, runs]]
  return result unless result.nil?
  if !(springs.include? '?')
    result = (runs == calc_runs(springs) ? 1 : 0)
    cache[[springs, runs]] = result
    return result
  end
  possible, springs, runs = check_runs(springs, runs)
  if !possible
    result = 0
  else
    str1 = springs.sub('?','.')
    str2 = springs.sub('?','#')
    result = permute_springs(str1, runs, cache) + permute_springs(str2, runs, cache)
  end
  cache[[springs, runs]] = result
  return result
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

def check_runs(springs, runs)
  spring_split = springs.split('?', 2)
  if spring_split != [] && spring_split[0] != ''
    if spring_split[0].end_with? '.'
      spring_split[1] = '?' + spring_split[1]
    else
      split2 = spring_split[0].split('.')
      return [true, springs, runs] if split2.length == 1
      extra = split2.delete_at(-1)
      spring_split[1] = extra + '?' + spring_split[1]
      spring_split[0] = split2.join('.')
    end
    temp_runs = calc_runs(spring_split[0])
    if !(runs.take(temp_runs.size) == temp_runs)
      return [false, springs, runs]
    else
      return [true, spring_split[1], runs[temp_runs.size..-1]]
    end
  end
  return [true, springs, runs]
end

valid_layouts = 0
input.each_with_index do |line, line_no|
  print "processing line #{line_no}\r"
  line.strip!
  springs, runs = line.split(' ')
  springs = ([springs]*5).join('?') # part 2
  runs = ([runs]*5).join(',')
  runs = runs.split(',').map(&:to_i)
  valid_layouts += permute_springs(springs, runs, {})
end

puts "\nvalid layouts: #{valid_layouts}"
