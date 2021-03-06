require 'json'
require 'open-uri'
require 'cgi'
require 'sinatra'

get '/' do
  "hello"
end

post '/lingr' do
  json = JSON.parse(request.body.string)
  ret = ""
  json["events"].each do |e|
    text = e['message']['text']
    if /^!!([\S]+)\s+(.+)$/m =~ text
      res = JSON.parse(open("http://api.dan.co.jp/lleval.cgi?l=#{$1}&s=#{CGI.escape($2)}").read)
      ret += res['stderr'].empty? ? res['stdout'] : res['stderr']
    end
  end
  ret.rstrip
end
