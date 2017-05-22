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
