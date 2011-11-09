require 'sinatra'

get '/code/:filename' do
    print ("get "+params[:filename]+"\n") 
    send_file '../device/code/'+params[:filename]
end

post '/code/:filename' do
    File.open('../device/code/'+params[:filename], 'w') {|f| f.write(params[:code])}
end

#get a list of files in JSON Format
get '/devices' do
    dirs = Dir.entries("../device/code")[2..-1]
    '["' + dirs.join('","') + '"]'
end

set :port, 9494
set :public, File.dirname(__FILE__) + '/static'
