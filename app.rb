require 'sinatra'
require 'json'

class MemoApp < Sinatra::Base
enable :method_override
json_file_path = './list.json'

# index
get '/' do
  File.open(json_file_path, 'r') do |file|
    @memo_list = JSON.load(file)
  end
  erb :index
end

# new
get '/new' do
  erb :new
end

delete '/destroy_memo/' do
  memo_id = params['memo_id']
  File.open(json_file_path, 'r+') do |file|
    @memo_list = JSON.load(file)
    @memo_list.delete(memo_id).to_s
    JSON.dump(@memo_list, file)
  end
  File.write(json_file_path, @memo_list.to_json)
  redirect to('/')
end


# show

get '/show' do
  memo_id = params['memo_id']
  File.open(json_file_path, 'r') do |file|
    @memo_list = JSON.load(file)
  end
  @memo_content = @memo_list[memo_id]
  @memo_id = memo_id
  erb :show
end

# save
post '/save' do

  memo_content = {}
  memo_content["MemoContent"] = params[:memo_content]
  File.open(json_file_path, 'r+') do |file|

  @memo_list = JSON.load(file)
  list_num = @memo_list.length + 1
  @memo_list[list_num] = memo_content
  file = nil

  JSON.dump(@memo_list, file)
  end
  File.write(json_file_path, @memo_list.to_json)
  redirect to('/')
end

# edit
get '/edit' do
  memo_id = params['memo_id']
  File.open(json_file_path, 'r+') do |file|
    @memo_list = JSON.load(file)
    @memo_content = @memo_list[memo_id]
    @memo_id = memo_id
  end
  erb :edit
end

patch '/change_memo/' do
  memo_id = params['memo_id']
  memo_content = {"MemoContent":params['memo_content']}
  File.open(json_file_path, 'r+') do |file|
    @memo_list = JSON.load(file)
  end
  @memo_list[memo_id] = memo_content
  File.write(json_file_path, @memo_list.to_json)
  redirect to('/')
end
end

run MemoApp.run!
