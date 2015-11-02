require "pry-byebug"

def auth(user)
  username = user["username"]
  password = user["password"]
  u = User.find_by(username: username)
  # binding.pry
  if u.nil?
    return false
  end
  if u.password == password
    return true
  end
  return false
end

def check(user)
  password = user["password"]
  re_password = user["re_password"]
  user["regist_date"] = nil
  if password == re_password
    user.delete("re_password")
    return user
  else
    return nil
  end
end

def tweet_array_to_hash(records_array, logged)
  rt = Array.new
  records_array.each do |tw|
    t = Hash.new()
    t["text"] = tw["content"]
    puts "tw[:content]", tw["content"]
    t["time"] = tw["created_at"]
    t["by_user"] = tw["username"]
    # below is made up
    t["favourite_number"] = 10
    t["comment"] = Hash.new
    t["comment"]["commenter_name"] = "fake_name_1"
    t["comment"]["content"] = "fake_content_2"
    t["comment"]["time"] = "2007-10-23 22:15:15 UTC"
    t["comment"]["reply_to"] = "fake_content_3"
    if logged
      #fake data
       t["has_this_user_favorited_this_tweet"] = false
    end
    rt << t
  end
  return rt
end

def first_50_tweets_lst
  /#
  return an array of hash
  #/
  sql = "SELECT T.content, T.created_at, T.retweet_id, U.username FROM tweets AS T, users AS U WHERE T.user_id = U.id ORDER BY T.created_at DESC LIMIT 50"
  records_array = ActiveRecord::Base.connection.execute(sql)
  rt = tweet_array_to_hash(records_array, false)
  return rt
end




def get_time_line_tweets(user_id)
  /#
  return an array of hash
  #/
  # s = "SELECT followee_id FROM follows WHERE follower_id = #{user_id}"
  sql = "SELECT T.content, T.created_at, T.retweet_id, U.username FROM tweets AS T, users AS U WHERE T.user_id = U.id AND T.user_id = #{user_id} OR T.user_id IN 
  (SELECT followee_id FROM follows WHERE follower_id = #{user_id} )"
  records_array = ActiveRecord::Base.connection.execute(sql)
  rt = tweet_array_to_hash(records_array, true)
  return rt
end

def get_time_line(user_id)
  image_url = "https://upload.wikimedia.org/wikipedia/commons/f/f6/Barack_Obama_and_Bill_Clinton_profile.jpg"
  
  rt = {}
  rt["logged_user_profile"] = {}
  rt["logged_user_profile"]["username"] = User.find_by(id: user_id).username
  rt["logged_user_profile"]["profile_photo_url"] = image_url
  rt["timeline_twitter_list"] = get_time_line_tweets(user_id)
  return rt
end

# print check({:re_password=>"abc", :password=>"abc"})


