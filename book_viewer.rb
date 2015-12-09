require "sinatra"
require "sinatra/reloader"
require "pry"

helpers do
  
  def in_paragraphs(text)
    text.split("\n\n").map do |line|
      "<p>#{line}</p>"
    end.join
  end
end

before do
  @contents = File.readlines("data/toc.txt")
end

get "/" do
  @title = "The Adventures of Sherlock Holms"
  erb :home
end

get "/chapters/:number" do
  number = params[:number].to_i
  chapter_name = @contents[number - 1]
  @title = "Chapter #{number}: #{chapter_name} "

  @chapter = File.read("data/chp#{number}.txt")

  erb :chapter
end

get "/search" do
  if params[:query]
    @results = []
    @contents.each_with_index do |_, indx|
      text = File.read("data/chp#{indx + 1}.txt")
      @results << indx + 1 if text.include?(params[:query])
    end
    @results
  end
  erb :search
end

not_found do
  redirect "/"
end
