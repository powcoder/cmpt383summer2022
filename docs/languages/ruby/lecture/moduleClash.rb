https://powcoder.com
代写代考加微信 powcoder
Assignment Project Exam Help
Add WeChat powcoder
# moduleClash.rb

module A
  def sayname
    puts "I'm A!"
  end
end

module B
  def sayname
    puts "I'm B!"
  end
end

class C
  # Try swapping the order of these lines.
  include B
  include A
end

c = C.new
c.sayname    # What does this print?
