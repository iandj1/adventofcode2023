input = File.open("inputs/20-sample.txt")
input = File.open("inputs/20.txt")

class Component
  @@components = []
  @@pulse_queue = [] # [src, dest, pulse]
  @@low = 0
  @@high = 0

  def self.score
    return @@low * @@high
  end

  attr_accessor :name, :type, :outputs, :inputs

  def initialize(name, type, outputs)
    @name = name
    @type = type
    @outputs = outputs
    @inputs = {}
    @@components << self
    @@broadcast = self if name == 'broadcast'
    @flipflop = false # off
  end

  def process_pulse(src, pulse)
    if pulse
      @@high += 1
    else
      @@low += 1
    end
    # puts "#{src&.name || 'button'} #{pulse ? 'high' : 'low'} ->, #{self.name}"
    return if @type == 'output'
    if @type == '%' # flipflop
      return if pulse
      @flipflop = !@flipflop
      out = @flipflop
    elsif @type == '&' # conjunction
      @inputs[src] = pulse
      if @inputs.values.all?(true)
        out = false
      else
        out = true
      end
    else # broadcast
      out = pulse
    end
    @outputs.each do |output|
      @@pulse_queue << [self, output, out]
    end
  end

  def self.process_pulses
    while !@@pulse_queue.empty?
      src, dest, pulse = @@pulse_queue.shift
      dest.process_pulse(src, pulse)
    end
  end

  def self.link_components
    @@components.each do |component|
      output_objects = []
      component.outputs.each do |output_name|
        output_object = @@components.find{|c| c.name == output_name}
        output_objects << output_object
        output_object.inputs[component] = false # low
      end
      component.outputs = output_objects
    end
  end

  def self.all_components
    @@components
  end

  def self.broadcast
    @@broadcast
  end
end

input.each do |line|
  line.strip!
  line = line.split(' -> ')
  if line[0].start_with? 'broadcaster'
    type = 'broadcast'
    name = 'broadcast'
  else
    type = line[0][0]
    name = line[0][1..-1]
  end
  outputs = line[1].split(', ')
  Component.new(name, type, outputs)
end
Component.new('output', 'output', [])
Component.new('rx', 'output', [])

Component.link_components

1000.times do
  Component.broadcast.process_pulse(nil, false)
  Component.process_pulses
end

puts "part 1: #{Component.score}"