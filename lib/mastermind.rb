class Code
  attr_reader :pegs

  def initialize(pegs)
    @pegs = pegs
  end

  PEGS = {
    "R" => "Red",
    "G" => "Green",
    "B" => "Blue",
    "Y" => "Yellow",
    "O" => "Orange",
    "P" => "Purple"
  }

  def self.parse(string)
    if string.chars.map(&:upcase).all? { |color| PEGS.has_key?(color) }
      pegs = [
        PEGS[string[0].upcase],
        PEGS[string[1].upcase],
        PEGS[string[2].upcase],
        PEGS[string[3].upcase]
      ]
      Code.new(pegs)
    else
      raise "Invalid color"
    end
  end

  def self.random
    pegs_array = PEGS.keys
    pegs = [
      PEGS[pegs_array[rand(5)]],
      PEGS[pegs_array[rand(5)]],
      PEGS[pegs_array[rand(5)]],
      PEGS[pegs_array[rand(5)]]
    ]
    Code.new(pegs)
  end

  def [](a)
    pegs[a]
  end

  def exact_matches(code)
    match_count = 0
    idx = 0
    while idx < 4
      if self[idx] == code[idx]
        match_count += 1
      end
      idx += 1
    end
    match_count
  end

  def near_matches(code)
    match_count = 0
    checked_i = []
    checked_j = []
    i = 0
    while i < 4
      j = 0
      while j < 4
        if self[i] == code[j] && (!checked_i.include?(i) && !checked_j.include?(j))
          match_count += 1
          checked_i << i
          checked_j << j
        elsif (self[i] == code[j] && i == j) && checked_j.include?(j)
          match_count -= 1
        end
        j += 1
      end
      i += 1
    end
    match_count
  end

  def ==(code)
    i = 0
    while i < 4
      if self[i].upcase != code[i].upcase
        return false
      end
      i += 1
    end
    true
  end

end

class Game
  attr_reader :secret_code

  def initialize(secret_code=nil)
    if secret_code.nil?
      @secret_code = Code.random
    else
      @secret_code = secret_code
    end
  end

  def get_guess
    Code.new(@secret_code)
  end

  def display_matches(code)
    print "exact matches: " + @secret_code.exact_matches(code).to_s
    print "\nnear matches: " + @secret_code.near_matches(code).to_s
  end

end
