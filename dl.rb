#!/usr/bin/env ruby
require 'fileutils'

season = ARGV[0]

Dir.chdir(Dir.glob("#{season}-*").first)

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
    system "youtube-dl -f hds-2048 -o \"%(autonumber)s.%(ext)s\" #{line}"

    # make list file of all partials
    Dir.glob('*.flv').sort.each do |file|
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
    system "</dev/null ffmpeg -f concat -safe 0 -i temp/partials.txt -c copy #{file_name}.flv"
    FileUtils.rm_r './temp'
  end
end