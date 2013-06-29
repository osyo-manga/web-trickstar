# -*- encoding: UTF-8 -*-
require 'sinatra'
require 'json'
require "mechanize"
require 'set'
require 'digest/sha1'
require 'erb'
require 'open-uri'

load "gyazo.rb"


def gyazo_from_url(url, width, height)
	png = "./image/#{Time.now.to_i}.png"
	result_phantomjs = `phantomjs capture.js #{url} #{png} #{width} #{height}`

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
	return "homu"
end

post '/api/gyazo/upload/' do
	if params[:file]
		File.read params[:file][:filename]
		save_path = "./temp/upload_#{Time.now.to_i}.html"
		File.open(save_path, "w") do |f|
			f.write params[:file][:tempfile].read
		end

		width  = params[:width] || 10
		height = params[:height] || 10
		return gyazo_from_url(save_path, width, height)
	else
		return "Not found"
	end
end


get '/api/gyazo/' do
	url    = params[:url]
	width  = params[:width] || 10
	height = params[:height] || 10
	if url
		return gyazo_from_url(url, width, height)
	end
	"Not found"
end


