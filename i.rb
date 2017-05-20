# I've just made this file, in a fresh directory
# I want to write some code, and see if I can debug
# and run it effectively on my Surface

# I'm brainstorming some ideas:
# - A Wikipedia scraper that will tell you anyone's age
# - A large ASCII countdown clock
# - A chess/checkers board that highlights legal moves
# - An HTML document builder
# - A blog simulation without a backend
# - Crossword builder
# - Hangman

# This is my first project:
# - Wiki-hangman
# Requirements:
# - Connect to Wikipedia
# - Select and download an article (random with sufficient length)
# - Find an uncommon word used on the page
# - Present the user with the name of the Wiki page
# - Allow the user to guess the word, hangman style
# - Maintain a running scoreboard

class PediaReader
  # Select and download a random Wikipedia article
  # Send to AnalyseArticle
  # Repeat if article does not meet criteria
  # Return article
end

class AnalyseArticle
  # Receive the article from PediaReader
  # Return false if article fails criteria
  # Criteria are TBD, but include:
  #     <stub> tags,
  #     article length,
  #     ..
end

class WordSelect
  # Select a suitable word from the article
  #     Reject numbers
  #     Reject common Words
  #     Reject long and short words
end

class Hangman
  # Receive title and word
  # Present title to reader and draw gameboard
  # Allow user to guess letters
  # Update the gameboard (use clear, cls)
  # Declare victory/defeat
  # Display scoreboard
end

class HighScore
  # Use File IO to write to scoreboard
  # Return score information
end

class Log
  # For debugging purposes, log stuff to file
end

class Game
  # Call on all of the classes above and tie it all together
end

#Log.write("Testing")
