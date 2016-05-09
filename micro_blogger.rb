require 'jumpstart_auth'
require 'bitly'

class MicroBlogger
	attr_reader :client

  	def initialize
    	@client = JumpstartAuth.twitter
  	end

  	# tweet a message
  	def tweet(message)
  		if message.length <= 140	
	   	@client.update(message)
	   else
	   	puts "Unable to tweet message below.  Message must be 140 characters or less."
	   	puts message
	   end
	end

	# send direct message
	def dm(target, message)
		# get names of all followers (target must be a follower in order to receive a direct message)
		screen_names = @client.followers.collect { |follower| @client.user(follower).screen_name }

		if screen_names.include?(target)
			puts "Trying to send #{target} this direct message:"
			puts message
			message = "d @#{target} #{message}"
			tweet(message)
		else # not a follower
			puts "Sorry, can't send a direct message to #{target}.  That user must be a follower of yours."
		end
	end

	# return array of all follower user names
	def followers_list
		screen_names = []
		# get screen names of followers, place into array
		@client.followers.each { |follower| screen_names << @client.user(follower).screen_name }
		return screen_names
	end

	# send direct message to all followers
	def spam_my_followers(message)
		# get followers
		followers = followers_list
		# send each the message
		followers.each {|follower| dm(follower, message)}

	end

	# show last tweet of all friends
	def everyones_last_tweet
		friends = @client.friends # returns array of friend objects

		puts "Everyone's last tweet:"
		friends.each do |friend|
			# find each friends last message
			print "#{@client.user(friend).screen_name} said ... #{@client.user(friend).status.text}"
			puts ""
		end
	end

	# shorten a url using bitly gem
	def shorten (original_url)
		puts "Shortening this URL: #{original_url}"

		Bitly.use_api_version_3
		bitly = Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6')
		return bitly.shorten(original_url).short_url
	end

	def run
		puts "\nWelcome to the Twitter Client"
		puts "\nThe following commands are available:"
		puts "\n\tt <msg> - tweet\n\tturl <msg url> - tweet wit URL\n\tdm <screen name> <msg> - direct message\n\tspam <msg> - spam all followers\n\telt - everyone's last tweet\n\ts - shorten url\n\tq - quit \n\n"
		puts ""
		command = ""
		while command != "q"
			print "Enter command: "
			input = gets.chomp
			parts = input.split(" ")
			command = parts[0]
			case command
			when 'q' then puts "Goodbye!"
			when 't' then tweet(parts[1..-1].join(" "))
			when 'turl' then tweet(parts[1..-2].join(" ") + " " + shorten(parts[-1]))
			when 'dm' then dm(parts[1], parts[2..-1].join(" "))
			when 'spam' then spam_my_followers(parts[1..-1].join(" "))
			when 'elt' then everyones_last_tweet
			when 's' then puts "The shortened URL is:  #{shorten(parts[1])}"
			else
				puts "Sorry, I don't know how to #{command}"
			end
		end
	end

end

blogger = MicroBlogger.new
blogger.run
