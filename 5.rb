input = File.open("inputs/5-sample.txt")
input = File.open("inputs/5.txt")


class ResourceMap
  @@all_res_maps = []

  attr_accessor :from, :to
  def self.all_maps
    @@all_res_maps
  end
  def self.next_map(resource)
    @@all_res_maps.detect{|res_map| res_map.from == resource}
  end
  def self.calculate_resource(source_name, dest_name, number)
    while source_name != dest_name
      map = next_map(source_name)
      number = map.lookup(number)
      source_name = map.to
    end
    number
  end
  def initialize(name)
    name.chomp!(' map:')
    @from, _, @to = name.split('-')
    @maps = []
    @@all_res_maps << self
  end
  def to_s
    "#{@from} to #{@to} map"
  end
  def add_map(map_str)
    dest, source, length = map_str.split(' ').map(&:to_i)
    source_range = source...(source+length)
    delta = dest - source
    @maps << [source_range, delta]
  end
  def lookup(source_number)
    map = @maps.detect{|map| map[0].cover? source_number}
    map.nil? ? source_number : source_number + map[1]
  end
end


seeds = input.readline.strip.split(':')[1].strip.split(' ').map(&:to_i)

res_map = nil
input.each do |line|
  line.strip!
  next if line.empty?
  if line =~ /to/
    res_map = ResourceMap.new(line)
  else
    res_map.add_map(line)
  end
end

locations = seeds.map{|seed| ResourceMap.calculate_resource('seed', 'location', seed)}

puts "part 1: #{locations.min}"
