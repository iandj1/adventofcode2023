input = File.open("inputs/7-sample.txt")
input = File.open("inputs/7.txt")

class Hand
  CardLookup = {
    'J' => 'A',
    '2' => 'B',
    '3' => 'C',
    '4' => 'D',
    '5' => 'E',
    '6' => 'F',
    '7' => 'G',
    '8' => 'H',
    '9' => 'I',
    'T' => 'J',
    'Q' => 'K',
    'K' => 'L',
    'A' => 'M'
  }
  CardReverseLookup = CardLookup.invert
  JokerBoost = {
    6 => 7, # 4 -> 5 of a kind
    4 => 6, # 3 -> 4 of a kind
    3 => 5, # 2 pair -> full house
    2 => 4, # 1 pair -> 3 of a kind
    1 => 2, # high card -> 1 pair
    0 => 1  # no cards -> high card
  }

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
    n_jokers = cards.count{|card| card == 'A'}
    cards.delete('A') # remove jokers
    score = nil
    card_counts = []
    cards.uniq.each do |card|
      card_counts << cards.count{|c| c == card}
    end
    card_counts.sort!.reverse!

    case card_counts[0]
    when 5
      # 5 of a kind
      score = 7
    when 4
      # 4 of a kind
      score = 6
    when 3
      if card_counts[1] == 2
        # full house
        score = 5
      else
        # 3 of a kind
        score = 4
      end
    when 2
      if card_counts[1] == 2
        # 2 pair
        score = 3
      else
        # 1 pair
        score = 2
      end
    when 1
      # high card
      score = 1
    else
      # no cards
      score = 0
    end

    n_jokers.times do
      score = JokerBoost[score]
    end
    score
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
