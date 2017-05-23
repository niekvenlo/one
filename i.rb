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
# [x] Connect to Wikipedia
# [x] Select and download an article (random with sufficient length)
# [x] Find an uncommon word used on the page
# [x] Present the user with the name of the Wiki page
# [x] Allow the user to guess the word, hangman style
# [ ] Maintain a running scoreboard

class Log
  # For debugging purposes, log stuff to file
  def Log.write(to_add)
    time = Time.now.strftime("%a %d - %H:%M")
    file = File.open("first.log", "a") { |f| f.puts time, to_add, "\n" }
  end
end

#DEFINE ERROR HANDLING
class NickError < StandardError
  def initialize(msg="Normal Nick type Error")
    Log.write(msg)
    super(msg)
  end
end
class PediaError < NickError; end
class HangmanError < NickError; end

class PediaReader
  # Select and download a random Wikipedia article
  # Send to AnalyseArticle
  # Repeat if article does not meet criteria
  # Return article
  attr_reader :title, :first_line, :word

  def initialize
    @minimum_word_length = 7
    @maximum_word_length = 14
    error_handler do
      @title, text_body = open_random_article
      stripped_text_body = strip_formatting(text_body)
      @first_line = get_first_line(stripped_text_body)
      @word = get_word(stripped_text_body)
    end
  end

  private
  def error_handler
    yield
    rescue
      retry
  end

  def open_random_article
    require 'open-uri'
    require 'json'
    url = 'https://en.wikipedia.org/w/api.php?action=query&prop=revisions&rvprop=content&format=json&generator=random&grnnamespace=0'
    json_page  = open(url,{ssl_verify_mode: 0}) {|f| f.read }
    page_hash = JSON.parse(json_page)
    title = page_hash['query']['pages'].values[0]['title']
    text_body = page_hash['query']['pages'].values[0]['revisions'][0]["*"]
    return [title,text_body]
  end

  def strip_formatting (wikitext)
    # Temporary replace \n with *newline*
    wikitext.gsub!("\n",'*newline*')
    # Strip any templates
        # Todo: improve behaviour for inline templates
    3.times.each { wikitext.gsub!(/{{2}.*?}{2}/,'{{') }
    wikitext.gsub!(/{{2}/,'')
    # Strip straight brackets
    wikitext.gsub!(/\[{2}(.+?)\]{2}/,'\1')
    wikitext.gsub!(/.+\|/,'')
    # Strip title quotes
    wikitext.gsub!(/\'{2,}/,'')
    #Strip references
    wikitext.gsub!(/<ref.*?\/ref>|\/>/,'')
    wikitext.gsub!(/<ref>.*?<\/ref>/,'')
    # Strip lists separate from the main body of the text
    ["References","External links","Bibliography","Further reading", "Gallery"].each do |str|
      idx = wikitext.downcase.index(str.downcase)
      wikitext.slice!(idx-2..-1) if !idx.nil?
    end
    # Strip URLs
    wikitext.gsub!(/\[http.*?>/,'')
    # Restore \n from *newline*
    wikitext.gsub!('*newline*',"\n")
    if "{}<>".chars.any? { |c| wikitext.include?(c) }
      raise PediaError.new("Text may not be clean")
    end
    if wikitext.length < 400
      raise PediaError.new("Article is too short")
    end
    return wikitext
  end

  def get_first_line(text_body)
    end_of_line = text_body.index(/\.( |\n)/)
    raise PediaError.new("First line is too short") if end_of_line < 50
    first_line = text_body.slice(0..end_of_line).strip
    raise PediaError.new("No title in first line") unless first_line.include?(@title)
    first_line
  end

  def get_word(text_body)
    # Select a suitable word from the article
    #     Reject numbers
    #     Reject common Words
    #     Reject long and short words
    words = text_body.split.reject do |word|
      word.include?("http") ||                          # Exclude any urls
      word.include?("disambiguation") ||                # Exclude disambiguation
      word.length < @minimum_word_length ||             # Exclude short words
      word.length > @maximum_word_length ||             # Exclude long words
      word.downcase != word ||                          # Exclude capitalised words, to explude proper names
      word.to_i.to_s == word ||                         # Exclude numbers
      word.chars.any? { |c| ".?!,*(')|=\'".include?(c)} # Exclude any words with
    end                                                 # accidentally attached punctuation
    rescue => e
      raise PediaError.new("Problem getting words: "+ e.message)
    else
      word = words[rand(words.length)]
    return word
  end
end

class Hangman
  # Receive title and word
  # Present title to reader and draw gameboard
  # Allow user to guess letters
  # Update the gameboard (use clear, cls)
  # Declare victory/defeat
  # Display scoreboard
  def initialize(title, first_line, word)
         @title = title
    @first_line = first_line
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
    puts "\n"*3

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
    puts "\n"*3
    puts @first_line
    puts "\n"*3

    # ENDPOINT SECTION
    if @word.length == @matches.length
      puts "Well done :)"
      @round_over = true
    elsif @guesses < 1
      puts "  You didn't get the answer in time. The answer was #{@word}"
      @round_over = true
    else
      puts "\n"
    end
    puts "\n"*15
    sleep(0.4)
  end
end

class Game
  # Call on all of the classes above and tie it all together
     article = PediaReader.new
       title = article.title
  first_line = article.first_line
        word = article.word
  hangman = Hangman.new(title, first_line, word)
end

Game.new







# TO DO:
# [x] Overhaul Wiki-scrape
# [x] Provide first line of the article for context
# [x] Retry Wiki-scrape when a good word is not found
# [ ] Allow for multiple rounds
# [ ] Log successes and failures
# [ ] Manage difficulty settings:
#   [x] Minimum word length
#   [ ] Number of guesses
#   [ ] Letter repetiveness of the word
#   [ ] Hide/Show context first line
