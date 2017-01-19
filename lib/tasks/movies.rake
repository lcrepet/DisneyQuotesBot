namespace :movies do
  task :seed, [:file_path] do |t, args|
    if File.exist?(args[:file_path])
      file = File.read(args[:file_path])
      movies = JSON.parse(file)
      movies.each do |movie|
        Movie.create(title_fr: movie['title_fr'], title_en: movie['title_en'])
      end
    end
  end
end
