# Yunlu Hao

# This module constructs, and demonstrates the use of, our calculator scanner.
# The statements are input and then processed, via command line.
# Upon finishing editing, we will call next_token method repeatedly to print out all tokens read.

require 'readline'

# Hash table for reserved identifiers
$token_table = {
  'clear' => 'CLEAR',
  'list'  => 'LIST',
  'quit'  => 'QUIT',
  'exit'  => 'EXIT',
  '='     => 'EQL',
  '+'     => 'ADD',
  '-'     => 'SUB',
  '*'     => 'MUL',
  '/'     => 'DIV',
  '**'    => 'POW',
  'sqrt'  => 'SQRT',
  'log'   => 'LOG',
  '('     => 'LPAREN',
  ')'     => 'RPAREN'
}

class Token
  # A single token.

  # Attributes:
  #     kind:  kind of the token
  #     value: name of an identifier (including invalid ones), or value of a numeral.

  attr_accessor :kind
  attr_accessor :value 
  
  def initialize(char)
    # Construct a token from a piece of string, char.
    if $token_table.key?(char)
      # reserved identifiers
      @kind = $token_table[char]

    elsif char =~ /^[a-zA-Z]\w*$/
      # other identifiers
      @kind = 'ID'
      @value = char

    elsif char =~ /^-?[\d\.]*([eE]\-?\d+)?$/

      # numerals
      @kind = 'NUMBER'
      @value = char.to_f
    elsif char =~ /^;$/
      @kind = 'EOF'
    else
      # invalid identifiers
      @kind = nil
      @value = char
    end
  end
  
  def to_s
    # Return the string representation of the token

    if @kind == 'ID' or @kind == 'INVALID'
      @kind + '(' + @value + ')'
    elsif @kind == 'NUMBER' 
      @kind + '(' + @value.to_s + ')'
    else
      # Return nil for invalid identifiers
      @kind
    end
  end
end

class Scanner
  # A calculator scanner.

  # Attributes:
  #     tokens: a queue of all tokens read so far.
  attr_accessor :tokens
  def initialize(text='')
    # Initialize the calculator scanner with an option piece of text.

    @tokens = Array.new
    line = Readline.readline('>', true) 
    self.feed(line)
  end
  
  def feed(text)
    # Parse text, the resulting tokens are stored in @tokens.

    
    regexp = /
      [a-zA-Z]\w* |                       # identifiers
      [=\+\/\(\)-] |                      # operators
      -?\d*\.\d*e\-?\d* |                 # numerals  
      -?\d*\.\d* |          
      -?\d+[eE]\-?\d* |        
      -?\d+ |           
      \*{1,2} |                           # operators
      [^\w\s\.\+\*\/-]+ |                  # invalid characters
      ^;+
    /x

    text.scan(regexp) do |w|
      if (w != " ")
        token = Token.new(w)
        @tokens << token
      end
    end
  end 


  def next_token
    if @tokens.empty?
      line = Readline.readline('>', true)
      if (line)
        self.feed(line)
        self.next_token
      else
        nil
      end
    else
      @tokens.shift
    end
  end

  def empty
    return @tokens.empty?
  end

  def peek
    if (not @tokens.empty?)
      return @tokens.first
    end
  end
end
