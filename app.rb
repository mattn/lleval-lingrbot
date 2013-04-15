require 'json'
require 'net/http'
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
    if text =~ /^!!([\S]+)\s+(.+)$/m
      res = JSON.parse(Net::HTTP.get("api.dan.co.jp", "/lleval.cgi?l=#{$1}&s=" + CGI.escape($2)))
      ret += res['stderr'].empty? ? res['stdout'] : res['stderr']
    end
  end
  ret.rstrip
end
