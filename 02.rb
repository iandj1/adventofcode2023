input = File.open("inputs/2-sample.txt")
input = File.open("inputs/2.txt")

limits = {
    red: 12,
    green: 13,
    blue: 14
}

sum = 0

input.each do |line|
    valid = true
    game_no = line.match(/Game (\d+)/)[1].to_i
    line.gsub!(/Game \d+: /, '')
    line.split('; ').each do |round|
        round.split(', ').each do |draw|
            draw = draw.split(' ')
            num = draw[0].to_i
            colour = draw[1]
            if num > limits[colour.to_sym]
                valid = false
            end
        end
    end
    if valid
        sum += game_no
    end
end

puts sum