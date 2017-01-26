namespace :quotes do
  task :seed, [:file_path] do |t, args|
    if File.exist?(args[:file_path])
      file = File.read(args[:file_path])
      quotes = JSON.parse(file)

      quotes.each do |quote|
        movie = Movie.find_by(title_fr: quote['title'])
        Quote.create(line: quote['quote'], movie: movie)
      end
    end
  end
end
