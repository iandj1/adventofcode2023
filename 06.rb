input = File.open("inputs/6-sample.txt")
input = File.open("inputs/6.txt")

times = input.readline.strip.split(':')[1].strip.split(/ +/).map(&:to_i)
distances = input.readline.strip.split(':')[1].strip.split(/ +/).map(&:to_i)

def record_counts(time, record)
  n_records = 0
  (0..time).each do |hold_time|
    if (time - hold_time) * hold_time > record
      n_records += 1
    elsif n_records > 0
      # past all possible record values, stop early
      break
    end
  end
  n_records
end

record_product = 1
times.each_with_index do |time, race_no|
  record = distances[race_no]
  record_product *= record_counts(time, record)
end

puts "part 1: #{record_product}"

time = times.join('').to_i
record = distances.join('').to_i

puts "part 2: #{record_counts(time, record)}"