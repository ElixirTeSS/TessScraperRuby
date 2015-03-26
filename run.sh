#!/bin/bash

ruby node_upload.rb
ruby package_upload.rb
ruby ebi_scraper.rb
ruby goblet_scraper.rb
ruby genome3d_scraper.rb
ruby legacy_software_carpentry_scraper.rb
ruby coursera_scraper.rb
ruby sib_scraper.rb

