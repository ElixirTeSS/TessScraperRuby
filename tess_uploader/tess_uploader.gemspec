Gem::Specification.new do |s|
  s.name        = 'tess_uploader'
  s.version     = '0.1.0'
  s.date        = '2015-03-03'
  s.summary     = 'Libraries for uploading files to http://tess.oerc.ox.ac.uk'
  s.description = 'Uses the CKAN API on http://tess.oerc.ox.ac.uk to upload data in the format being used by the TeSS project.'
  s.authors     = ['Milo Thurston','Niall Beard']
  s.email       = 'milo.thurston@oerc.ox.ac.uk'
  s.files       = ['lib/tess_uploader.rb','lib/tuition.rb','lib/organisation.rb', 'lib/node.rb', 'lib/package.rb']
  s.homepage    = 'https://github.com/ElixirUK/TessScraperRuby'
  s.license     = 'BSD'
end
