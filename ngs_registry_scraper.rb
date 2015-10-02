#!/usr/bin/env ruby

require 'open-uri'
require 'json'
require 'tess_uploader'


$lessons = {}
$debug = false
$json_file = 'https://bioinformatics.upsc.se/trainers/details.json'
$owner_org = 'ngs_registry'
$topics = {}
$root_url = 'https://microasp.upsc.se/ngs_trainers/Materials/tree/master/'


$lessons = JSON.parse(open($json_file).read)



# Create the organisation.
org_title = 'NGS Registry'
org_name = $owner_org
org_desc = 'GitLab registry containing NGS Training Materials'
org_image_url = ''
homepage = 'https://microasp.upsc.se/'
node_id = ''
organisation = Organisation.new(org_title,org_name,org_desc,org_image_url,homepage,node_id)
Uploader.check_create_organisation(organisation)



# do the uploads
$lessons.each do |lesson|
  material = lesson[1]
  relative_path = lesson[0]
  course = Tuition::Tutorial.new
  course.url = $root_url + relative_path
  course.owner_org = $owner_org
  course.title = material['title']
  course.set_name($owner_org,material['title'])
  if material['full'].nil?
    course.description = material['title']
    course.notes = "#{material['title']} from #{$root_url + key}, added automatically."
  else
    course.description = material['full'].join('')
    course.notes = material['full'].join('')
  end


  puts "course = #{course.dump}\n\n\n\n"
  course.format = 'html'

  # Before attempting to create anything we need to check if the resource/dataset already exists, updating it
  # as and where necessary.
  Uploader.create_or_update(course)
  #print "Course: #{course.dump}\n\n\n\n\n"
end


