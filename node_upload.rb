require 'tess_uploader'
require 'yaml'  

begin
    nodes = YAML.load_file('nodes.yml')
    nodes.each do |node| 
        title, info = node
        name = title.downcase.gsub(' ', '-')
        node = Node.new(title, name, \
                        info['country_code'], info['description'], \
                        info['image_url'], info['tec'], info['trc'], info['hon'])
        Uploader.create_node(node)
    end
rescue 
    print "Problem loading nodes file \n"
end
