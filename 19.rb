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

# ratings
input.each do |line|
  line.strip!
  line.delete!('{}')
  rating = {}
  line.split(',').each do |var|
    var, val = var.split('=')
    rating[var] = val.to_i
  end
  ratings << rating
end

sum = 0

ratings.each do |rating|
  next_rule = 'in'
  while !['A', 'R'].include? next_rule
    rules[next_rule].each do |rule|
      if rule.is_a? String # catch all rule
        next_rule = rule
      else
        var, op, num, dest = rule
        val = rating[var]
        method = val.method(op)
        if method.call(num)
          next_rule = dest
          break
        end
      end
    end
  end
  sum += rating.values.sum if next_rule == 'A'
end

puts "part 1: #{sum}"