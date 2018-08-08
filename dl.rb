#!/usr/bin/env ruby
require 'fileutils'
require 'optparse'


season = ARGV.last
flv = false
ext = '.mp4'
dl_options = ''

# get options
OptionParser.new do |o|
    o.on('-flv', 'FLV') { flv = true }
    o.parse!
end

if flv
  ext = '.flv'
  dl_options += '-f hds-2048 '
end

# match to season directory and cd if it exists
dir = Dir.glob("#{season}-*").first.to_s
abort 'Season directory not found' unless !dir.empty? && Dir.chdir(dir)

File.open('list.txt', 'r') do |list|
  list.each_line do |line|

    # skip if lines starts with #
    next if line.start_with? '#'

    # download files to temp dir
    # mtv downloads come out in multiple pieces
    # autonumber to preserve order
    FileUtils.mkdir_p 'temp'
    Dir.chdir 'temp'
    system "youtube-dl #{dl_options} -o \"%(autonumber)s.%(ext)s\" #{line}"

    # make list file of all partials
    Dir.glob("*#{ext}").sort.each do |partial|
      open('partials.txt', 'a') { |partials_list_line|
        partials_list_line.puts "file '#{partial}'"
      }
    end

    Dir.chdir '../'

    # create file name as S##E##
    # if line contains # use everything after that as ep name, else use last two chars
    line = line.gsub("\n", '')
    season_padded = season.to_s.rjust(2, '0')
    episode_padded = line.include?('#') ? line.partition('#').last : line.chars.last(2).join
    file_name = "S#{season_padded}E#{episode_padded}"

    # use ffmpeg to concat the partials
    system "</dev/null ffmpeg -f concat -safe 0 -i temp/partials.txt -c copy #{file_name}#{ext}"
    FileUtils.rm_r './temp'
  end
end