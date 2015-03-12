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
