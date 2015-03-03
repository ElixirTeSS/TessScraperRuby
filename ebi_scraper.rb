#!/usr/bin/env ruby

load 'uploader.rb'
load 'tuition.rb'

require 'open-uri'
require 'nokogiri'

$root_url = 'http://www.ebi.ac.uk'
$owner_org = 'european-bioinformatics-institute-ebi'
$lessons = {}
$debug = false


def parse_data(page)

end

def extract_keywords(text)
  # Remove 'Topic:', newlines, and white space.
  # Split into array of topics and reject any empty ones
  # Format for CKAN Uploader
  text.gsub!('Topic:', '')
  text.gsub!(/\n/, '')
  text.gsub!(/\s+/,' ')
  keywords = text.split(' ')
  tags = []
  keywords.each do |keyword|
    if keyword == '' or keyword.length < 3
        keywords.delete(keyword)
    else
        tags << {'name' => keyword.gsub!(/\W+/,'')}
    end
  end
  return tags

end

def last_page_number
  # This method needs to be updated to find the actual final page.
  return 2
end


# Scrape all the pages.
first_page = '/training/online/course-list'
scrape_page(first_page)
1.upto(last_page_number) do |num|
    page = first_page + '?page=' + num.to_s
    puts "Scraping page: #{num.to_s}"
    parse_data(page)
end

# Create the organisation.
org_title = 'European Bioinformatics Institute (EBI)'
org_name = 'european-bioinformatics-institute-ebi'
org_desc = 'EMBL-EBI provides freely available data from life science experiments, performs basic research in computational biology and offers an extensive user training programme, supporting researchers in academia and industry.'
org_image_url = 'http://www.theconsultants-e.com/Libraries/Clients/European_Bioinformatics_Institute.sflb.ashx'
organisation = Organisation.new(org_title,org_name,org_desc,org_image_url)
Uploader.check_create_organisation(organisation)


# Upload all the data.
$lessons.each_key do |key|
  course = Tuition::Tutorial.new
  course.url = $root_url + key
  course.owner_org = $owner_org
  course.title = $lessons[key]['name']
  course.notes = $lessons[key]['description']
  course.set_name($owner_org,$lessons[key]['name'])
  course.tags = $lessons[key]['topics']
  course.format = 'html'

  # Before attempting to create anything we need to check if the resource/dataset already exists, updating it
  # as and where necessary.
  Uploader.create_or_update(course)

end
