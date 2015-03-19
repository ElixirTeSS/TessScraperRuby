#!/usr/bin/env ruby

require 'open-uri'
require 'json'
require 'tess_uploader'


$lessons = {}
$debug = false
$root_url = 'https://api.coursera.org/api/catalog.v1/courses'
$category_url = 'https://api.coursera.org/api/catalog.v1/categories'
$session_url = 'https://api.coursera.org/api/catalog.v1/sessions'
$owner_org = 'coursera'
$categories = {}
$audience = {
    '0' => 'Basic undergraduates',
    '1' => 'Advanced undergraduates or beginning graduates',
    '2' => 'Advanced graduates',
    '3' => 'Other'
}

def parse_data(page)
  return JSON.parse(open($root_url + page).read)
end

def parse_categories
  data = JSON.parse(open($category_url).read)['elements']
  data.each do |entry|
    $categories[entry['id']] = entry['name']
  end
end

def get_session(page)
 return JSON.parse(open("#{$session_url}/#{page.to_s}").read)['elements']
end


puts "DATA: #{parse_categories}"

# Create the organisation.
org_title = 'Coursera'
org_name = $owner_org
org_desc = 'Coursera is an education platform that partners with top universities and organizations worldwide, to offer courses online for anyone to take, for free.'
org_image_url = 'http://upload.wikimedia.org/wikipedia/commons/e/e5/Coursera_logo.PNG'
homepage = 'https://www.coursera.org/'
node_id = ''
organisation = Organisation.new(org_title,org_name,org_desc,org_image_url,homepage,node_id)
Uploader.check_create_organisation(organisation)