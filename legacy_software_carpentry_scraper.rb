#!/usr/bin/env ruby

require 'tess_uploader'


$lessons = {}
$debug = false
$git_dir = "#{ENV['HOME']}/Work/Web/bc/"
$owner_org = 'software-carpentry'
$git_url = "https://github.com/swcarpentry/bc/tree/gh-pages/"
$skill_levels = {'novice' => %w{extras git hg matlab python r ref shell sql teaching},
                 'intermediate' => %w{doit git make python r regex shell sql webdata}}


def parse_data
  $skill_levels.each_pair do |k,v|
    v.each do |value|
      #puts "Got #{k} lesson category entitled #{value}."
      files = Dir["#{$git_dir}#{k}/#{value}/*.md"]
      files.each do |file|
        basename = File.basename(file)
        next if basename == "README.md"
        next if basename == "index.md"
        File.foreach(file).with_index do |line,i|
          break if i >= 5
          if line =~ /title:/
            # We have a lesson, and need to save the URL, title, and tags.
            title = line.chomp.gsub(/title: /,'')
            url = "#{$git_url}#{k}/#{value}/#{basename}"
            tags = [{'name' => k.capitalize}, {'name' => value.capitalize}]
            $lessons[url] = {}
            $lessons[url]['tags'] = tags
            $lessons[url]['title'] = title
            break
          end
        end
      end
    end
  end
end


parse_data


# Create the organisation.
org_title = 'Software Carpentry'
org_name = $owner_org
org_desc = 'The Software Carpentry Foundation is a non-profit organization whose members teach researchers basic software skills.'
org_image_url = 'http://software-carpentry.org/img/software-carpentry-banner.png'
homepage = 'http://software-carpentry.org/'
node_id = ''
organisation = Organisation.new(org_title,org_name,org_desc,org_image_url,homepage,node_id)
Uploader.check_create_organisation(organisation)

# Upload all the data.
$lessons.each_key do |key|
  course = Tuition::Tutorial.new
  course.url = key
  course.owner_org = $owner_org
  course.title = $lessons[key]['title']
  course.notes = "#{$lessons[key]['title']} from #{key}, added automatically."
  course.set_name($owner_org,$lessons[key]['title'])
  course.tags = $lessons[key]['tags']
  course.format = 'html'

  # Before attempting to create anything we need to check if the resource/dataset already exists, updating it
  # as and where necessary.
  #puts "COURSE: #{course.to_json}"
  Uploader.create_or_update(course)

end