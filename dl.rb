#!/usr/bin/env ruby
require 'fileutils'
require 'json'

arg = ARGV.last.dup
file = File.open 'seasons.json'
seasons = JSON.parse(file.read)

# regex match argument to a season
selection = seasons.find {|season, episodes| /#{arg}.*/.match season}

# if season not found
if not selection
	puts 'Season info not found, try one of the following:'
	puts seasons.keys
	exit
end

season = selection[0]
episodes = selection[1]

# make directory and change to it
FileUtils.mkdir_p season
Dir.chdir season

# download each episode
episodes.each do |episode|
	file_name = episode[1]
	url = episode[0]
	ext = file_name.partition('.').last.prepend('.')
	dl_options = ext == '.flv' ? '-f hds-2048 ' : '-f \'bestvideo[height<=480]+bestaudio/best[height<=480]\''

	next puts "#{file_name} already exists" if File.exist? file_name

	# download files to temp dir
	# mtv downloads come out in multiple pieces
	# autonumber to preserve order
	FileUtils.rm_r 'temp' if Dir.exists? 'temp'
	FileUtils.mkdir 'temp'

	Dir.chdir 'temp' do
		puts "\n\n\nDownloading #{url} \r\n\n"
		system "youtube-dl #{dl_options} -o \"%(autonumber)s.%(ext)s\" #{url}"

		# make list file of all partials
		Dir.glob("*#{ext}").sort.each do |partial|
			open('partials.txt', 'a') do |partials_list_line|
				partials_list_line.puts "file '#{partial}'"
			end
		end
	end

	# use ffmpeg to concat the partials
	system "</dev/null ffmpeg -f concat -safe 0 -i temp/partials.txt -c copy #{file_name}"
	FileUtils.rm_r 'temp'
end
