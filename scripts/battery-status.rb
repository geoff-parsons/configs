#!/usr/bin/env ruby
ioreg = `ioreg -l`
max = ioreg.match(/"MaxCapacity" = ([\d]+)/)[1].to_f rescue nil
current = ioreg.match(/"CurrentCapacity" = ([\d]+)/)[1].to_f rescue nil
puts "#{(current / max * 100).floor}%"