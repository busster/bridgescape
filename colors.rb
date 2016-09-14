require 'rubygems'
require 'nokogiri'
require 'open-uri'



color_palette = Nokogiri::HTML(open("https://coolors.co/app"))


colors = color_palette.xpath('//*[@id="colors"]/div[1]')

p colors
# //*[@id="colors"]/div[1]