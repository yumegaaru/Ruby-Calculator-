# Yunlu Hao
# calc.rb


require 'readline'
require_relative "scan.rb"

puts "****************** Scanner ready ******************"




class Calc 
	def initialize
		@known_id = {'PI' => Math:: PI,}
		@myScanner = Scanner.new
		@token = @myScanner.peek
		program  
	end

	def program
		continue = true
		while(continue)
			if (not @myScanner.empty)
				@token = @myScanner.next_token
				puts statement
				#deal with ; in the same line
				#END is the token for end of file 
		        while @token.kind == 'EOF'
		          @token = @myScanner.next_token
		          puts statement
		        end	
			else 
				puts 'PLEASE GIVE THE CORRECT FORMAT'
			end	
			@myScanner.feed(Readline.readline('>', true))
			
		end
	end

	def statement
		#we need to check the next token without actually consuming it
		next_t = @myScanner.peek
		if (@token.kind == 'ID' && next_t.kind == 'EQL')
			id = @token.value
			puts 'YOU ARE NOW ASSIGNING THE VALUES'
			@token = @myScanner.next_token #get EQL
			@token = @myScanner.next_token #consume EQL
			result = exp
			@known_id[id] = result
			result
		elsif (@token.kind == 'CLEAR' && next_t.kind == 'ID')
			@token = @myScanner.next_token 
			id = @token.value
			clear(id)
		elsif (@token.kind == 'LIST')
			puts 'HERE IS THE LIST'
			list
		elsif (@token.kind == 'QUIT' or @token.kind == 'EXIT')
			puts 'QUIT BY MANUAL'
			exit
		else 
			exp
		end
	end

	def exp
		#check out whether it is the positive or negative
		if (@token.kind == 'SUB')
			@token = @myScanner.next_token
			result = - term
		else 
			result = term
		end

		while (@token.kind == 'ADD' or @token.kind == 'SUB')
			if @token.kind == 'ADD'
				@token = @myScanner.next_token
				result += term
			else
				@token = @myScanner.next_token
				result -= term
			end
		end
		result
	end

	def term
		result = power
		while (@token.kind == 'MUL' or @token.kind == 'DIV')
			if @token.kind == 'MUL'
				@token = @myScanner.next_token
				result *= power
			else
				@token = @myScanner.next_token
				result /= power
			end
		end
		result
	end

	def power
		result = factor
		while (@token.kind == 'POW')
			@token = @myScanner.next_token
			result = result ** power
		end
		result
	end

	def factor
		if (@token.kind == 'ID')
			if (@known_id.has_key?(@token.value))
				val = @known_id[@token.value]
				@token = @myScanner.next_token
				return val
			else
				puts 'YOU DO NOT HAVE THE VALUE OF THIS ID'
			end
		elsif (@token.kind == 'NUMBER')
			token = @token
			if (not @myScanner.empty)
				@token = @myScanner.next_token
			end
			
			return token.value
		elsif (@token.kind == 'LPAREN')
			@token = @myScanner.next_token #consume (
			result = exp
			if (not @myScanner.empty)
				@token = @myScanner.next_token
			end
			return result
		elsif (@token.kind == 'SQRT')
			@token = @myScanner.next_token #consume sqrt
			@token = @myScanner.next_token #consume (
			result = Math.sqrt(exp)
			if (not @myScanner.empty)
				@token = @myScanner.next_token
			end
			return result
		elsif (@token.kind == 'LOG')
			@token = @myScanner.next_token #consume log
			@token = @myScanner.next_token #consume (
			result = Math.log(exp)
			if (not @myScanner.empty)
				@token = @myScanner.next_token
			end
			return result
		else
			puts 'PLEASE GIVE THE CORRECT EXPRESSION, THANKS'
		end
	end

	def list
		if (@known_id.size == 0) 
      		puts "NOTHING IN THE LSIT" 
    	else
	    	@known_id.each do |key, value|
	      		key 
	      		value.to_s
	      	end
    	end
	end

	def clear(id)
		if @known_id.has_key?(id)
			puts 'NOTICE! YOU ARE DELETING '
			@known_id.delete(id)
		else
			puts 'ERROR: ID IS NOT EXIS'
		end
	end
end

Calc.new
















