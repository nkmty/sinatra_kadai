require 'sinatra'
require 'json'

class MemoApp < Sinatra::Base
  enable :method_override
  json_file_path = './list.json'

  # root ルートはメモ一覧へリダイレクトします
  get '/' do
    redirect to('/memos')
  end

  # index メモ一覧
  get '/memos' do
    File.open(json_file_path, 'r') do |file|
      @memo_list = JSON.load(file)
    end
    erb :index
  end

  # new メモ新規作成画面
  get '/memos/new' do
    erb :new
  end

  # show メモ詳細画面
  get '/memos/:id' do
    memo_id = params['id']
    if memo_id == "new"
      erb :new
    end
    File.open(json_file_path, 'r') do |file|
      @memo_list = JSON.load(file)
    end
    @memo_content = @memo_list[memo_id]
    @memo_id = memo_id
    erb :show

  end

  # メモ削除
  delete '/memos/:id' do
    memo_id = params['id']
    File.open(json_file_path, 'r+') do |file|
      @memo_list = JSON.load(file)
      @memo_list.delete(memo_id).to_s
      JSON.dump(@memo_list, file)
    end
    File.write(json_file_path, @memo_list.to_json)
    redirect to('/')
  end

  # create メモ保存
  post '/memos' do
    memo_content = {}
    memo_content["memo_content"] = params[:memo_content]
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

  # edit メモ編集画面
  get '/memos/:id/edit' do
    memo_id = params['id']
    File.open(json_file_path, 'r+') do |file|
      @memo_list = JSON.load(file)
      @memo_content = @memo_list[memo_id]
      @memo_id = memo_id
    end
    erb :edit
  end

  # patch メモ内容更新
  patch '/memos/:id' do
    memo_id = params['memo_id']
    memo_content = {"memo_content":params['memo_content']}
    File.open(json_file_path, 'r+') do |file|
      @memo_list = JSON.load(file)
    end
    @memo_list[memo_id] = memo_content
    File.write(json_file_path, @memo_list.to_json)
    redirect to('/')
  end
end

run MemoApp.run!
