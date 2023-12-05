input = File.open("inputs/5-sample.txt")
input = File.open("inputs/5.txt")

seeds = input.readline.strip.split(':')[1].strip.split(' ').map(&:to_i)

res_maps = []
input.each do |line|
  line.strip!
  next if line.empty?
  if line =~ /to/
    res_maps << []
  else
    dest, source, length = line.split(' ').map(&:to_i)
    source_range = source..(source+length-1)
    delta = dest - source
    res_maps[-1] << [source_range, delta]
  end
end

seed_ranges = seeds.each_slice(2).map{|start, length| start..(start+length-1)}

def range_boundaries(ranges)
  ranges.map{|range| [range.first - 0.5, range.last + 0.5]}.flatten.uniq
end

def split_ranges(ranges, boundaries)
  boundaries.each do |boundary|
    ranges.map! do |range|
      if range.cover? boundary
        range = [(range.first)..(boundary.floor), (boundary.ceil)..(range.last)]
      end
      range
    end
    ranges.flatten!
  end
  ranges
end

def apply_maps(input_ranges, map_ranges)
  boundaries = range_boundaries(map_ranges.map(&:first))
  input_ranges = split_ranges(input_ranges, boundaries)
  output_ranges = []
  input_ranges.each do |input_range|
    mapped = false
    map_ranges.each do |map_range, delta|
      if map_range.cover? input_range
        output_ranges << ((input_range.first + delta)..(input_range.last + delta))
        mapped = true
        break
      end
    end
    output_ranges << input_range if !mapped
  end
  output_ranges
end

res_maps.each do |maps|
  seed_ranges = apply_maps(seed_ranges, maps)
end

puts seed_ranges.map(&:first).min