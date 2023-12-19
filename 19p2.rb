input = File.open("inputs/19-sample.txt")
input = File.open("inputs/19.txt")

rules = {}
ratings = []

# rules
input.each do |line|
  line.strip!
  break if line == ''
  rule_name, line = line.split('{')
  line.chomp!('}')
  line_rules = []
  line.split(',').each do |rule_str|
    if !rule_str.include? ':' # catch all rule
      line_rules << rule_str
    else
      match = rule_str.match(/(\w+)([<>])(\d+):(\w+)/)
      line_rules << [match[1], match[2], match[3].to_i, match[4]]
    end
  end
  rules[rule_name] = line_rules
end

def total_valid(ratings, rules, rule_name)
  if rule_name == 'R'
    return 0
  elsif rule_name == 'A'
    return ratings.values.inject(1){|product, range| range.size * product} # return combinations
  end
  rules[rule_name].each do |rule|
    if rule.is_a? String
      return total_valid(ratings, rules, rule)
    end
    var, op, num, dest = rule
    low = ratings[var].first
    high = ratings[var].last
    method1 = low.method(op)
    method2 = high.method(op)
    if method1.call(num) && method2.call(num)
      return total_valid(ratings, rules, dest) # range fully passes
    elsif !method1.call(num) && !method2.call(num)
      next # range does not pass at all
    else
      # split range around test number
      ratings2 = ratings.dup
      if op == '>'
        ratings[var] = (low..num)
        ratings2[var] = ((num+1)..high)
      else
        ratings[var] = (low..(num-1))
        ratings2[var] = (num..high)
      end
      return total_valid(ratings, rules, rule_name) + total_valid(ratings2, rules, rule_name)
    end
  end
end

ratings = {
  "x" => (1..4000),
  "m" => (1..4000),
  "a" => (1..4000),
  "s" => (1..4000)
}

puts "part 2: #{total_valid(ratings, rules, 'in')}"