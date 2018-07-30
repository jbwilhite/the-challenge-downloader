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
unless !dir.empty? && Dir.chdir(dir)
  abort 'Season directory not found'
end

File.open('list.txt', 'r') do |file|
  file.each_line do |line|

    # skip if lines starts with #
    if line.start_with? '#'
        next
    end

    # download files to temp dir
    # mtv downloads come out in multiple pieces
    # autonumber to preserve order
    FileUtils.mkdir_p 'temp'
    Dir.chdir 'temp'
    system "youtube-dl #{dl_options} -o \"%(autonumber)s.%(ext)s\" #{line}"

    # make list file of all partials
    Dir.glob('*.mp4').sort.each do |file|
      open('partials.txt', 'a') { |f|
        f.puts file
      }
    end

    Dir.chdir '../'

    # create file name as S##E##
    season_padded = season.to_s.rjust(2, '0')
    episode_padded = line.gsub("\n",'').chars.last(2).join
    file_name = "S#{season_padded}E#{episode_padded}"

    # use ffmpeg to concat the partials
    system "</dev/null ffmpeg -f concat -safe 0 -i temp/partials.txt -c copy #{file_name}.mp4"
    FileUtils.rm_r './temp'
  end
end