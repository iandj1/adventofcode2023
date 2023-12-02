start = Time.now

input = File.open("inputs/2-sample.txt")
input = File.open("inputs/2.txt")

sum = 0

input.each do |line|
    max_cubes = {
        red: 0,
        green: 0,
        blue: 0
    }
    game_no = line.match(/Game (\d+)/)[1].to_i
    line.gsub!(/Game \d+: /, '')
    line.split('; ').each do |round|
        round.split(', ').each do |draw|
            draw = draw.split(' ')
            num = draw[0].to_i
            colour = draw[1]
            max_cubes[colour.to_sym] = [max_cubes[colour.to_sym], num].max
        end
    end
    sum += max_cubes.values.inject(:*)
end

puts sum