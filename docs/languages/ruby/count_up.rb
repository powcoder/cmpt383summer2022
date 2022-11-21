https://powcoder.com
代写代考加微信 powcoder
Assignment Project Exam Help
Add WeChat powcoder
# count_up.rb

#
# Repeats the code between { and } 10 times. The |i| is the argument passed to
# the block. In this case the value of i comes from 10.times.
#
10.times {|i| puts "This is sentence #{i+1}."}

#
# Prints a line of 25 '-' characters.
#
puts '-' * 25

#
# Instead of { and }, you can use do and begin on multiple lines.
#
10.times do |i|
	puts "This is statement #{i+1}."
end

puts '-' * 25

puts "How many times to repeat? "
n = gets.to_i.abs  # to_i converts the value to an int
                   # abs calculates the absolute value
n.times do |i|
	puts "This is line #{i+1}."
end
