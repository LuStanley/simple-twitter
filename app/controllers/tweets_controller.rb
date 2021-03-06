class TweetsController < ApplicationController


  def index
    #把order(followers_count: :desc)放在 index page 這樣就能同步更新。當在首頁按下follow的時候。
    @users_all = User.all

    @users_all.each do |user|
      user.followers_count = user.followers.size
      user.save
    end

    @users = @users_all.order(followers_count: :desc).limit(10)# 基於測試規格，必須講定變數名稱，請用此變數中存放關注人數 Top 10 的使用者資料

    @tweet = Tweet.new
    @ordered_tweets = Tweet.order(created_at: :desc)
    @tweets = @ordered_tweets.all


  end

  def create
    @tweet = Tweet.new(tweet_params)
    @tweet.user = current_user
    @tweet.save!
    redirect_to tweets_path
  end

  def like
    @tweet = Tweet.find(params[:id])
    @tweet.likes.create!(user: current_user)
    redirect_to tweets_path
  end

  def unlike
    @tweet = Tweet.find(params[:id])
    like = Like.where(tweet: @tweet, user: current_user)
    like.destroy_all
    redirect_to tweets_path
  end

  private

  def tweet_params
    params.require(:tweet).permit(:description)
  end


end
