require_relative 'validation.rb'

class Common
  include Validation

  protected

  def initialize(name: nil, number: nil)
    @name = name
    @number = number
    @owner = self.class
  end
end

class SomeClass < Common
  def initialize(name: nil, number: nil)
    super
  end
  # able to perform few types of validation on a single attribute at once
  validate :name, presence: true, format: /a{3}/
  validate :owner, type: 'SomeClass'
end

class OtherClass < Common
  def initialize(name: nil, number: nil)
    super
  end
  # can check for presence: false aka absence
  validate :name, presence: false
  validate :number, format: /[0-9]/
  validate :owner, type: 'SomeClass'
end

first = SomeClass.new(name: 'aaa', number: 7)
second = OtherClass.new(name: 'aaa', number: 7)
third = OtherClass.new(number: 'a')
fourth = SomeClass.new(name: 'aa')

# won't raise an exception and returns true
puts "first - #{first.validate!}"

# returns true because validations completed successfully
puts "first - #{first.valid?}"

# returns false because OtherClass validates for presence: false while name is present
puts "second - #{second.valid?}"

# returns false because number is nil, so it does not match required format
puts "third - #{third.valid?}"

# will raise an exception, because name does not match a format while it still present
puts "fourth - #{fourth.validate!}"