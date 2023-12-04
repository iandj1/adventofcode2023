input = File.open("inputs/4-sample.txt")
input = File.open("inputs/4.txt")

sum = 0
card_scores = []
n_cards = []

input.each_with_index do |line, card_no|
    line.strip!
    line = line.split(':')[1].strip
    winning, mine = line.split('|')
    winning = winning.strip.split(/ +/)
    mine = mine.strip.split(/ +/)
    common = winning & mine
    sum += 2**(common.length - 1) unless common.empty?
    card_scores << common.length
    n_cards << 1
end

puts "part 1: #{sum}"

card_scores.each_with_index do |score, card_no|
    score.times.with_index do |new_card|
        new_card += card_no + 1
        n_cards[new_card] += n_cards[card_no]
    end
end

puts "part 2: #{n_cards.inject(:+)}"