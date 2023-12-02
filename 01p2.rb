input = File.open("inputs/1p2-sample.txt")
input = File.open("inputs/1.txt")

num_lookup = {
    'one' => '1',
    'two' => '2',
    'three' => '3',
    'four' => '4',
    'five' => '5',
    'six' => '6',
    'seven' => '7',
    'eight' => '8',
    'nine' => '9'
}

nums = num_lookup.keys + (0..9).to_a.map(&:to_s)
nums_r = num_lookup.keys.map(&:reverse) + (0..9).to_a.map(&:to_s)
regex = nums.join('|')
regex_r = nums_r.join('|')

sum = 0

input.each do |line|
    line.strip!
    first = line.match(regex)[0]
    last = line.reverse.match(regex_r)[0].reverse

    first = num_lookup[first] || first
    last = num_lookup[last] || last
    sum += (first + last).to_i
end

puts sum