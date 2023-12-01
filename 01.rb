start = Time.now

input = File.open("inputs/1-sample.txt")
input = File.open("inputs/1.txt")

sum = 0

input.each do |line|
    line.strip!
    ints = line.scan(/[0-9]/)
    sum += (ints[0] + ints[-1]).to_i
end

puts sum