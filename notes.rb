TO DO
# To review more:
#  [ ] Grep / Regex
#  [ ] Git
#  [ ] Erb
#  [ ] JavaScript
#  [ ] Byebug / Pry

DEBUGGING
# Returns an array of all local variables. Useful in debugging issues involving scope.
local_variables


CLASSES
# Classes are convenient wrappers of functionality. You can create instances of classes,
# but you can also define a "utility class" that is never instantiated and contains only
# class methods (self.do_something)


METHODS
# 1. Yield, Method do.
  # Method do first calls the method, which can yield control to the block.
def error_handler(*args)
  puts "1. Doing this, then yielding to the block"
  yield
  # The following will run only if there wasn't an error.
  # Otherwise, we move straight to +rescue+
  puts "3b. The block has finished running without an error"
rescue StandardError => ex
  puts ex.message
  puts "4. If an error was raised, we retry this entire method, so ..\n"
  retry
end
error_handler do
  puts "2. Now running the block"
  num = rand(20)
  if num < 15 # Probsbly goin to raise an error
    raise StandardError, "3a. An error was raised"
  end
end
# 2. Bang. Params
a, *b = 1, 2, 3 #=> a = 1, b =[2,3]



LOGIC
# Case can compare using Regex and can compare against multiple comparators
case "2"
when /^1/, "2"
  puts "the string starts with one or is '2'"
end

# I don't understand the benefit of the following code:
# "The tests for if and elsif may have side-effects. The most common use of side-effect is to cache a value into a local variable"
if a = object.some_value
  # do something to a
end

# Tip from JS; when assigning a value during an evaluation, adding parentheses can help clarify the code
if ((x = 5)) then ... end           # Confirm this works in Ruby


HASHES
# 1. Hashes can take a Proc as a default value through the default_proc method
# 2. The delete_if and keep_if method can be used with a block to remove or keep entries that match the block
# 3. Use a hash to pass named parameters. Notice that the curly brackets may be omitted.
Person.create(name: "John Doe", age: 27)

def self.create(params)
  @name = params[:name]
  @age  = params[:age]
end
# 4. Use the dig method to access deeply nested hashes.
user = {
  user: {
    address: {
      street1: '123 Main street'
    }
  }
}
user.dig(:user, :address, :street1) # => '123 Main street'


STRINGS
# 1. Case-insensitive string comparison with casecmp? method
"aBcDe".casecmp?("abcde")     #=> true
# 2. Pad a string with center method. See also ljust and rjust
"hello".center(20, '=') #=> =======hello=========
# 3. Strip a trailing character with chomp method
"hello".chomp("lo") #=> "hel"
# 4. Select all instances that match a Regex from a string
"cruel world".scan(/(...)/) #=> [["cru"], ["el "], ["wor"]] 
