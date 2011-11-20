# Copyright 2010 Heinz Haeberle
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
require 'sinatra'

get '/code/:filename/:dummy' do
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
