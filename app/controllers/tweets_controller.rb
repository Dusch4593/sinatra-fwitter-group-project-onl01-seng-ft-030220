class TweetsController < ApplicationController
  get '/tweets' do
    if is_logged_in?
      @tweets = Tweet.all
      erb :"tweets/index"
    else
      redirect '/login'
    end
  end

  get '/tweets/new' do
    if is_logged_in?
      erb :"tweets/new"
    else
      redirect '/login'
    end
  end

  post '/tweets' do
    if is_logged_in?
      if params[:content] == ""
        redirect '/tweets/new'
      else
        @tweet = current_user.tweets.build(content: params[:content])
        if @tweet.save
          redirect "/tweets/#{@tweet.id}"
        else
          redirect '/tweets/new'
        end
      end
    else
      redirect '/login'
    end
  end


  get '/tweets/:id' do
    if is_logged_in?
      @tweet = Tweet.find_by(params[:id])
      erb :"tweets/show"
    else
      redirect '/login'
    end
  end

  get '/tweets/:id/edit' do
    if is_logged_in?
      @tweet = Tweet.find_by(params[:id])
      erb :"tweets/edit"
    else
      redirect '/login'
    end
  end

  patch '/tweets/:id' do
    if is_logged_in?
      if params[:content] == ""
        redirect "/tweets/#{params[:id]}/edit"
      else
        @tweet = Tweet.find_by(params[:id])
        if @tweet && @tweet.user == current_user
          if @tweet.update(content: params[:content])
            redirect "/tweets/#{@tweet.id}"
          else
            redirect "/tweets/#{@tweet.id}/edit"
          end
        else
          redirect '/tweets'
        end
      end
    else
      redirect '/login'
    end
  end

  delete '/tweets/:id/delete' do
    if is_logged_in?
      @tweet = Tweet.find_by(params[:id])
      if @tweet && @tweet.user == current_user
        @tweet.delete
      else
        redirect '/tweets'
      end
    else
      '/login'
    end
  end

end
