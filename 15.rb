input = File.open("inputs/15-sample.txt")
input = File.open("inputs/15.txt")

def do_hash(string)
  value = 0
  string.chars.each do |char|
    value += char.ord
    value *= 17
    value %= 256
  end
  value
end

sum = 0

boxes = Array.new(256) {Hash.new}
input.readline.strip.split(',').each do |step|
  sum += do_hash(step)

  label = step.match(/\w+/)[0]
  box = boxes[do_hash(label)]
  if step.include? '='
    box[label] = step[-1].to_i
  else # '-'
    box.delete(label)
  end
end

puts "part 1: #{sum}"

power = 0
boxes.each_with_index do |box, box_no|
  box.values.each_with_index do |lens, slot_no|
    power += (box_no + 1) * (slot_no + 1) * (lens)
  end
end

puts "part 2: #{power}"
