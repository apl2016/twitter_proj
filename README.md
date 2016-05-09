# twitter_proj
Command line client to interact with Twitter
- Uses Jumpstart_Auth gem 
- command line user to specify whether to 
  -- tweet
  -- tweet with a shortened url using bitly gem
  -- send a direct message
  -- spam followers
  -- see everybody’s last tweet
  -- exit the program

  Commands are in the format of:
  tweet:  t <msg>
  tweet with url:  turl <msg url>
  direct message:  dm <user> <msg>
  spam all followers:  spam <msg>
  see everyone's last tweet:  elt
  exit:  q