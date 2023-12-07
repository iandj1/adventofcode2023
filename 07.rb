input = File.open("inputs/7-sample.txt")
input = File.open("inputs/7.txt")

class Hand
  CardLookup = {
    '2' => 'A',
    '3' => 'B',
    '4' => 'C',
    '5' => 'D',
    '6' => 'E',
    '7' => 'F',
    '8' => 'G',
    '9' => 'H',
    'T' => 'I',
    'J' => 'J',
    'Q' => 'K',
    'K' => 'L',
    'A' => 'M'
  }
  CardReverseLookup = CardLookup.invert

  attr_accessor :hand, :bid

  def initialize(hand, bid)
    @hand = hand.chars.map{|card| CardLookup[card]}.join('')
    @bid = bid.to_i
  end

  def to_s
    "#{@hand.chars.map{|card| CardReverseLookup[card]}.join('')} #{@bid}"
  end

  def type
    cards = @hand.chars
    case cards.uniq.length
    when 1
      # 5 of a kind
      return 7
    when 2
      # 4 of a kind or full house
      if [1,4].include? cards.count{|card| card == cards.first}
        # 4 of a kind
        return 6
      else
        # full house
        return 5
      end
    when 3
      # 3 of a kind or 2 pair
      cards.each do |test_card|
        return 4 if cards.count{|card| card == test_card} == 3
        return 3 if cards.count{|card| card == test_card} == 2
      end
    when 4
      # single pair
      return 2
    when 5
      # high card
      return 1
    end
  end

  def <=>(other)
    return -1 if self.type < other.type
    return 1 if self.type > other.type
    self.hand <=> other.hand
  end
end

hands = []

input.each do |line|
  line.strip!
  hand, bid = line.split(' ')
  hands << Hand.new(hand, bid)
end

sum = 0
hands.sort.each_with_index do |hand, index|
  sum += (index + 1) * hand.bid
end

puts sum
