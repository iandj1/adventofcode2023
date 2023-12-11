input = File.open("inputs/11-sample.txt")
input = File.open("inputs/11.txt")

class Galaxy
  @@galaxies = []
  @@max_row = 0
  @@max_col = 0

  attr_accessor :row, :col

  def initialize(row, col)
    @row = row
    @col = col
    @@galaxies << self
    @@max_row = [row, @@max_row].max
    @@max_col = [col, @@max_col].max
  end

  def distance(other)
    (@row - other.row).abs + (@col - other.col).abs
  end

  def self.empty_rows
    empty_rows = []
    (0..@@max_row).each do |row|
      empty_rows << row if @@galaxies.none?{|galaxy| galaxy.row == row}
    end
    empty_rows
  end
  def self.empty_cols
    empty_cols = []
    (0..@@max_col).each do |col|
      empty_cols << col if @@galaxies.none?{|galaxy| galaxy.col == col}
    end
    empty_cols
  end

  def self.expand_universe(multiple)
    empty_rows.reverse.each do |row|
      @@galaxies.each do |galaxy|
        galaxy.row += (multiple-1) if galaxy.row > row
      end
    end
    empty_cols.reverse.each do |col|
      @@galaxies.each do |galaxy|
        galaxy.col += (multiple-1) if galaxy.col > col
      end
    end
  end

  def self.total_distance
    sum = 0
    @@galaxies.combination(2).each do |gal_1, gal_2|
      sum += gal_1.distance(gal_2)
    end
    sum
  end
end

input.each_with_index do |line, row|
  line.strip.chars.each_with_index do |char, col|
    Galaxy.new(row, col) if char == '#'
  end
end

# Galaxy.expand_universe(2)
# puts "part 1: #{Galaxy.total_distance}"

Galaxy.expand_universe(1000000)
puts "part 2: #{Galaxy.total_distance}"
