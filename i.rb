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
  def self.article_select
    require 'open-uri'
    url = 'https://en.wikipedia.org/w/api.php?action=query&prop=revisions&rvprop=content&format=json&generator=random&grnnamespace=0'
    page  = open(url,{ssl_verify_mode: 0}) {|f| f.read }
    return Page.analyse(page)
  end
end

class Page
  # Receive the article from PediaReader
  # Return false if article fails criteria
  # Criteria are TBD, but include:
  #     <stub> tags,
  #     article length,
  #     ..
  def Page.analyse(json_page)
    require 'json'
    page_hash = JSON.parse(json_page)
    title = page_hash['query']['pages'].values[0]['title']
    haha = page_hash['query']['pages'].values[0]['revisions'][0]["*"]

    document_text = haha.gsub("\n"," ").gsub(/({{2}.*?}{2})/,"").gsub(/(={2+}.*?={2+})/,"").gsub(/\[{2}|\]{2}/,"").gsub(/<.*?>/,"")
    the_word = Page.word_select(document_text)
    return [title,the_word]
  end

  def Page.word_select(document_text)
    # Select a suitable word from the article
    #     Reject numbers
    #     Reject common Words
    #     Reject long and short words
    words = document_text.split.reject { |word|
      word.length<7 || word.include?("http") || word.include?("Category") || word.chars.any? { |c| ",*(')|\'".include?(c)} || word.downcase != word
    }
    word_count = Hash.new(0)
    words.each { |word| word_count[word] += 1 }
    return word_count.find { |k,v| v == 2 }[0]
  end
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
  def Log.write(to_add)
    # Do local File IO stuff
    #require 'time'
    time = Time.now.strftime("%a %d - %H:%M")
    #time = Time.now.utc.iso8601
    file = File.open("first.log", "a") { |f| f.puts time, to_add, "\n" }
#    file.puts time, to_add, "\n"
#    file.close
  end
end

class Game
  # Call on all of the classes above and tie it all together
  title, word = PediaReader.article_select
  puts title
  puts word
end

#Log.write("ddd")
Game.new




#puts reduced#["hello"] => "goodbye"
