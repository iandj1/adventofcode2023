start = Time.now
input = File.open("inputs/9-sample.txt")
input = File.open("inputs/9.txt")

def diff_arr(input_arr)
  output_arr = []
  (1...input_arr.length).each do |i|
    output_arr << (input_arr[i] - input_arr[i-1])
  end
  output_arr
end

def next_num(input_arr)
  return 0 if input_arr.all?{|n| n == 0 }
  input_arr[-1] + next_num(diff_arr(input_arr))
end

sum1 = 0
sum2 = 0
input.each do |line|
  line.strip!
  arr = line.split(' ').map(&:to_i)
  sum1 += next_num(arr)
  sum2 += next_num(arr.reverse)
end

puts "part 1: #{sum1}"
puts "part 2: #{sum2}"

puts "took #{Time.now - start}"