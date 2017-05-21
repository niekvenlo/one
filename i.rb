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

class Log
  # For debugging purposes, log stuff to file
  def Log.write(to_add)
    # Do local File IO stuff
    time = Time.now.strftime("%a %d - %H:%M")
    file = File.open("first.log", "a") { |f| f.puts time, to_add, "\n" }
  end
end

class PediaReader
  # Select and download a random Wikipedia article
  # Send to AnalyseArticle
  # Repeat if article does not meet criteria
  # Return article
  def open_article
    require 'open-uri'
    require 'json'
    url = 'https://en.wikipedia.org/w/api.php?action=query&prop=revisions&rvprop=content&format=json&generator=random&grnnamespace=0'
    json_page  = open(url,{ssl_verify_mode: 0}) {|f| f.read }
    page_hash = JSON.parse(json_page)
    title = page_hash['query']['pages'].values[0]['title']
    haha = page_hash['query']['pages'].values[0]['revisions'][0]["*"]

    document_text = haha.gsub("\n"," ").gsub(/({{2}.*?}{2})/,"").gsub(/(={2+}.*?={2+})/,"").gsub(/\[{2}|\]{2}/,"").gsub(/<.*?>/,"")
    the_word = word_select(document_text)
    return [title,the_word]
  end

  def word_select(document_text)
    # Select a suitable word from the article
    #     Reject numbers
    #     Reject common Words
    #     Reject long and short words
    words = document_text.split.reject { |word|
      word.length<7 || word.include?("http") || word.include?("Category") || word.chars.any? { |c| ",*(')|=\'".include?(c)} || word.downcase != word
    }
    word_count = Hash.new(0)
    words.each { |word| word_count[word] += 1 }
    return word_count.find { |k,v| v == 2 }[0]
  end
end



class Page




end

class Hangman
  # Receive title and word
  # Present title to reader and draw gameboard
  # Allow user to guess letters
  # Update the gameboard (use clear, cls)
  # Declare victory/defeat
  # Display scoreboard
  def initialize(title, word)
    @title = title
    @word = word
    @guesses = 5
    @matches = Hash.new
    play
  end

  def play
    round_over = false
    until round_over
      paint
      letter = gets.chomp
      if ("a".."z").to_a.include?(letter)
        if @word.include?(letter)
          @word.each_char.with_index { |char,idx|
            @matches[idx] = letter if char == letter
          }
        else
          @guesses -= 1
        end
      end
    end
  end

  def paint
    # GAME HEADER
    puts "\n"*30
    puts "  WIKI-HANGMAN"
    puts "  ============"
    puts "\n"*5

    # TITLE
    puts "  The title of this round is:"
    puts "  #{@title.upcase}  \n\n"

    # CHALLENGE
    puts "  The word you're looking for is #{@word.length} letters long"
    unless @guesses < 1
      puts "  You have #{@guesses} #{@guesses>1 ? "guesses" : "guess"} left"
      puts "  \u2592"*@guesses
    end
    puts "\n"*3

    # GAME BOARD
    board = ''
    @word.length.times.each { |idx|
      if @matches[idx]
        board += "  #{@matches[idx]}"
      else
        board += "  _"
      end
    }
    puts board
    puts "\n"*5

    # ENDPOINT SECTION
    if @word.length == @matches.length
      puts "Well done :)"
      @round_over = true
    elsif @guesses < 1
      puts "  You didn't get the answer in time. The answer was #{@word}"
      @round_over = true
    end
    puts "\n"*20
    sleep(0.4)
  end
end

class HighScore
  # Use File IO to write to scoreboard
  # Return score information
end


class Game
  # Call on all of the classes above and tie it all together
  reader = PediaReader.new
  title, word = reader.open_article
  #title, word = ["MANU V STEELINK CONTRACTING SERVICES LTD", "employment"]
  Log.write("From \"#{title}\", the word is #{word}")
  hangman = Hangman.new(title, word)
end

#Log.write("ddd")
Game.new




#puts reduced#["hello"] => "goodbye"


# TO DO:
# [ ] Overhaul Wiki-scrape
# [ ] Provide first line of the article for context
# [ ] Retry Wiki-scrape when a good word is not found
# [ ] Allow for multiple rounds
# [ ] Log successes and failures
# [ ] Manage difficulty settings:
#   [ ] Minimum word length
#   [ ] Number of guesses
#   [ ] Letter repetiveness of the word
#   [ ] Hide/Show context first line
