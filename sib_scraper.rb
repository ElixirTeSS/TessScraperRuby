#!/usr/bin/env ruby

require 'open-uri'
require 'nokogiri'
require 'tess_uploader'

$root_url = 'http://edu.isb-sib.ch/course/index.php?categoryid=2'
$owner_org = 'sib'
$lessons = {}
$debug = false


def parse_data(page)
  # As usual, use a local page for testing to avoid hammering the remote server.
  if $debug
    puts 'Opening local file.'
    begin
      f = File.open("sib.html")
      doc = Nokogiri::HTML(f)
      f.close
    rescue
      puts 'Failed to open sib.html file.'
    end
  else
    puts "Opening: #{$root_url + page}"
    doc = Nokogiri::HTML(open($root_url + page))
  end

  # Now to obtain the exciting course information!
  #links = doc.css('#wiki-content-container').search('li')
  #links.each do |li|
  #  puts "LI: #{li}"
  #end

  links = doc.css("div.coursebox").map do |coursebox|
    course = coursebox.at_css("a")
    if course
        url = course['href']
        name = course.text.strip
        description = coursebox.at_css("p").text.strip
        puts "url: #{url || 'missing'}\nname: #{name || 'missing'}\ndescription: #{description || 'missing'}" if $debug
        $lessons[url] = {}
        $lessons[url]['name'] = name
        $lessons[url]['description'] = description
    end
  end
end

# parse the data
parse_data('course/index.php?categoryid=2')


# create the organisation
org_title = 'SIB'
org_name = 'sib'
org_desc = <<EOF
Swiss Institute of Bioinformatics
EOF
org_image_url = 'http://www.isb-sib.ch/templates/sib/images/sib_logo.png'
home_page = 'http://edu.isb-sib.ch/'
organisation = Organisation.new(org_title,org_name,org_desc,org_image_url, home_page, 'switzerland')
Uploader.check_create_organisation(organisation)

# do the uploads
$lessons.each_key do |key|
  course = Tuition::Tutorial.new
  course.url = $root_url + key
  course.owner_org = $owner_org
  course.title = $lessons[key]['name']
  course.set_name($owner_org,$lessons[key]['name'])
  if $lessons[key]['description'].nil?
      course.description = $lessons[key]['name']
      course.notes = "#{$lessons[key]['name']} from #{$root_url + key}, added automatically."
  else
      course.description = $lessons[key]['description']
      course.notes = $lessons[key]['description']

  end
  course.format = 'html'

  # Before attempting to create anything we need to check if the resource/dataset already exists, updating it
  # as and where necessary.
  Uploader.create_or_update(course)
  #print "Course: #{course.dump}"


end
