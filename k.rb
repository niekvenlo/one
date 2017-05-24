def met(num=100)
  num+rand(rand(8))
end


describe "#met" do
  context "when given valid input" do
    it "should return around #{avg=104}" do
      10.times do
        expect(met).to be_within(4).of avg
      end
    end
    it "should return around a variable" do
      10.times do |g|
        expect(met(g)).to be_within(4).of g+2
      end
    end
  end
  context "when given invalid input" do
    it "should give TypeError when given a character" do
      340.times.each do
        # Gets a random ASCII character (as String)
        random_letter = (32+rand(255-32)).chr #127
        expect { met(random_letter) }.to raise_error(TypeError)
        #expect(met("a")).to raise_error(TypeError) # This syntax doesn't work.
      end
    end
  end
  context "funsies" do
    it "should do bullshit" do
      expect(false).to be(false)
    end
  end
end


describe "An example of the error matchers" do
  it "should show how the error matchers work" do
      expect { 1/0 }.to raise_error(ZeroDivisionError)
      expect { 1/0 }.to raise_error("divided by 0")
      expect { 1/0 }.to raise_error("divided by 0", ZeroDivisionError)
      # The following syntax does not work because it raises an error in the test suite
      # Nesting the code that raises the error in a block is necessary here.
      #expect(1/0).to raise_error(ZeroDivisionError)
   end
end
