# TessScraperRuby

As the name suggests, a Ruby version of TessScraper.

It should have the same functionality (when finished). 

# Installation

Tested for Ruby version 2.1.3


```shell
git clone git@github.com:ElixirUK/TessScraperRuby.git
  
cd tess_uploader && gem build tess_uploader.gemspec && gem install tess_uploader-0.0.1.gem

cd .. && bundle install

```

# Usage

```shell
cp example_uploader_config.txt uploader_config.txt
```
Fill in the info in uploader_config.txt. The API key can be found on your user dashboard.
```shell
ruby goblet_scraper.rb

ruby ebi_scraper.rb
```
