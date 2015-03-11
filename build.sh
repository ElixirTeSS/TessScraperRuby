#!/bin/zsh

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" 
rvm use ruby-head@scraper
cd tess_uploader && gem build tess_uploader.gemspec && gem install tess_uploader-0.0.1.gem && cd ..

