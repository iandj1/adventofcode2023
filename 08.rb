input = File.open("inputs/8-sample.txt")
input = File.open("inputs/8-sample2.txt")
input = File.open("inputs/8-sample3.txt")
input = File.open("inputs/8.txt")


directions = input.readline.strip.chars.map{|dir| dir == 'L' ? 0 : 1}

nodes = {}

input.each do |line|
  line.strip!
  next if line.empty?
  current, options = line.split(' = ')
  options.delete!('()')
  nodes[current] = options.split(', ')
end

current = 'AAA'
steps = 0

while current != 'ZZZ'
  steps += 1
  direction = directions.shift
  directions << direction
  current = nodes[current][direction]
end

puts "part 1: #{steps}"


starts = nodes.keys.select{|node| node.end_with?('A')}

lcm = 1

starts.each do |start|
  current = start
  steps = 0
  while steps == 0 || !current.end_with?('Z')
    steps += 1
    direction = directions.shift
    directions << direction
    current = nodes[current][direction]
  end
  lcm = lcm.lcm(steps)
end

puts "part 2: #{lcm}"