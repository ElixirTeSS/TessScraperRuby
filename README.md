# TessScraperRuby

This repository contains the tess_uploader gem and scripts.

The tess_uploader gem uploads content to an instance of the TeSS website. 

The scripts are used to seed the TeSS website with content. Some scrape websites and repositories for Training Materials; others like the package_upload and node_upload read from local yml configuration files.  

The scripts then write to the specified TeSS database using the API.


# Installation

Tested for Ruby version 2.1.3

You can use build.sh to compile the uploader gem and bundle install to install required gems.
```shell
. ./build.sh
bundle install
```

Copy the example_uploader_config.txt into upload_config.txt and fill it in with the correct configuration to your server and your API key. The API key can be found on the user dashboard when you log in to your account on the TeSS instance.
```shell
cp example_uploader_config.txt uploader_config.txt
```

# Usage

To run all of the scripts run 
```shell
. ./run.sh
```
This sequentially calls all scripts. At present these are:
```shell
ruby node_upload.rb  
ruby package_upload.rb
ruby ebi_scraper.rb
ruby goblet_scraper.rb
ruby genome3d_scraper.rb
ruby legacy_software_carpentry_scraper.rb
ruby coursera_scraper.rb
ruby sib_scraper.rb
```

Each script can be run independently.

## Nodes

Node Configuration is kept in the nodes.yml file. Instructions on how to modify it are written in comments at the top. Once modified, run as below to upload to the server specified in the upload_config.txt
```shell
ruby node_upload.rb
```



