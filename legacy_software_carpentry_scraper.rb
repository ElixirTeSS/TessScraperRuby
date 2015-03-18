#!/usr/bin/env ruby

require 'tess_uploader'


$lessons = {}
$debug = false
$git_dir = "#{ENV['HOME']}/Work/Web/bc/"
$git_url = "https://github.com/swcarpentry/bc/tree/gh-pages/"
$skill_levels = {'novice' => %w{extras git hg matlab python r ref shell sql teaching},
                 'intermediate' => %w{doit git make python r regex shell sql webdata}}


def parse_data
  $skill_levels.each_pair do |k,v|
    v.each do |value|
      puts "Got #{k} lesson category entitled #{value}."
      files = Dir["#{$git_dir}#{k}/#{value}/*.md"]
      files.each do |file|
        basename = File.basename(file)
        next if basename == "README.md"
        next if basename == "index.md"
        File.foreach(file).with_index do |line,i|
          break if i >= 5
          puts "LINE: #{line.class}: #{line}"
          if line =~ /title:/
            # We have a lesson, and need to save the URL, title, and tags.
            title = line.chomp.gsub(/title: /,'')
            url = "#{$git_url}#{k}/#{value}/#{basename}"
            tags = [{'name' => k.capitalize}, {'name' => value.capitalize}]
            $lessons[url] = {}
            $lessons[url]['tags'] = tags
            $lessons[url]['name'] = title
            break
          end
        end
      end
    end
  end
end


parse_data
puts "Lessons: #{$lessons}"