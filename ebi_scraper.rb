#!/usr/bin/env ruby

require 'open-uri'
require 'nokogiri'
require 'tess_uploader'

$root_url = 'http://www.ebi.ac.uk'
$owner_org = 'european-bioinformatics-institute-ebi'
$lessons = {}
$debug = false


def parse_data(page)
  doc = Nokogiri::HTML(open($root_url + page))

  #first = doc.css('div.item-list').search('li')
  first = doc.css('li.views-row')
  first.each do |f|
    titles = f.css('div.views-field-title').css('span.field-content').search('a')
    desc = f.css('div.views-field-field-course-desc-value').css('div.field-content').search('p')
    topics = f.css('div.views-field-tid').css('span.field-content').search('a')

    #puts "TITLES: #{titles.css('a')[0]['href']}, #{titles.text}"
    #puts "DESC: #{desc.text}"
    #puts "TOPICS: #{topics.collect{|t| t.text }}"

    href = titles.css('a')[0]['href']
    $lessons[href] = {}
    $lessons[href]['description'] = desc.text.strip
    $lessons[href]['text'] = titles.css('a')[0].text
    $lessons[href]['topics'] = topics.map{|t| {'name' => t.text.gsub!(/\W/,' ')} } # Replaces extract_keywords
                                                                                  # Non-alphanumeric purged

  end

end


def last_page_number
  # This method needs to be updated to find the actual final page.
  return 2
end


# Scrape all the pages.
first_page = '/training/online/course-list'
parse_data(first_page)
1.upto(last_page_number) do |num|
    page = first_page + '?page=' + num.to_s
    puts "Scraping page: #{num.to_s}"
    parse_data(page)
end


# Create the organisation.
org_title = 'European Bioinformatics Institute (EBI)'
org_name = 'european-bioinformatics-institute-ebi'
org_desc = 'EMBL-EBI provides freely available data from life science experiments, performs basic research in computational biology and offers an extensive user training programme, supporting researchers in academia and industry.'
org_image_url = 'http://www.ebi.ac.uk/miriam/static/main/img/EBI_logo.png'
organisation = Organisation.new(org_title,org_name,org_desc,org_image_url)
Uploader.check_create_organisation(organisation)


# Upload all the data.
$lessons.each_key do |key|
  course = Tuition::Tutorial.new
  course.url = $root_url + key
  course.owner_org = $owner_org
  course.title = $lessons[key]['text']
  course.notes = $lessons[key]['description']
  course.set_name($owner_org,$lessons[key]['text'])
  course.tags = $lessons[key]['topics']
  course.format = 'html'

  # Before attempting to create anything we need to check if the resource/dataset already exists, updating it
  # as and where necessary.
  #puts "COURSE: #{course.to_json}"
  Uploader.create_or_update(course)

end
