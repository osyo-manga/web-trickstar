# -*- encoding: UTF-8 -*-
require 'sinatra'
require 'json'

load "gyazo.rb"


def gyazo_from_url(url, width, height, top, left, bottom, right)
	png = "./tmp/#{Time.now.to_i}.png"
	result_phantomjs = `phantomjs capture.js #{url} #{png} #{width} #{height} #{top} #{left} #{bottom} #{right}`

	if result_phantomjs.empty?
		return "サイトのキャプチャに失敗しました。"
	end

	begin
		gyazo = Gyazo.new ""
		result = gyazo.upload png
	rescue
		return "Failed Gyazo upload."
	end
	return result
end


get '/' do
	return "hello trickstar."
end

# curl -F file=@web.rb.html http://localhost:5000/api/gyazo/upload/?width=600
post '/api/gyazo/upload/' do
	if params[:file]
		save_path = "./temp/upload_#{Time.now.to_i}.html"
		File.open(save_path, "w") do |f|
			f.write params[:file][:tempfile].read
		end

		width  = params[:width] || 10
		height = params[:height] || 10
		top    = params[:top] || 0
		left   = params[:left] || 0
		bottom = params[:bottom] || 0
		right  = params[:right] || 0
		return gyazo_from_url(save_path, width, height, top, left, bottom, right)
	else
		return "Not found"
	end
end

# http://localhost:5000/api/gyazo/?url=https://www.google.co.jp/
# http://localhost:5000/api/gyazo/?url=http://www.amazon.co.jp/dp/B00DFTV49Y&bottom=500&right=800

get '/api/gyazo/' do
	url    = params[:url]
	width  = params[:width] || 10
	height = params[:height] || 10
	top    = params[:top] || 0
	left   = params[:left] || 0
	bottom = params[:bottom] || 0
	right  = params[:right] || 0
	if url
		return gyazo_from_url(url, width, height, top, left, bottom, right)
	end
	"Not found"
end


get '/detail/phantomjs' do
	`phantomjs --version`
end


