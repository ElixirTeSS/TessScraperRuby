require 'package'
require 'tess_uploader'

packages = [
'Query Sequence and Variation Data',
'Known structure in PDB',
'Close Relative - Homology Modelling',
'Remote Relative - Structure Prediction',
'Structure Analysis and Model Quality',
'Active Site',
'Binding Site',
'Interfaces',
'Post-Translational Modifications',
'Conserved Sites',
'Visualization',
'Structure Based Analysis of Impact',
'Sequence Based Analysis of Impact'
]

begin
      packages.each do |package| 
        name = package.downcase.gsub(' ', '-')
        package = Package.new(package, name)
        Uploader.create_package(package)
    end
rescue Exception => ex
    puts ex.message
    puts ex.backtrace.join("\n")
    puts "----------------------------" 
    puts "Problem loading nodes file \n"
end
