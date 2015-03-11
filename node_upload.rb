require 'tess_uploader'
require 'yaml'  

begin
    nodes = YAML.load_file('nodes.yml')
    nodes.each do |node| 
        title, info = node
        name = title.downcase.gsub(' ', '-')
        node = Node.new(title, name, \
                        info['country_code'], info['description'],
                        info['home_page'], info['image_url'], 
                        info['twitter'],
                        info['tec']['name'], info['tec']['email'],
                        info['trc']['name'], info['trc']['email'],
                        info['hon']['name'], info['hon']['email'])
       node = Uploader.create_or_update_node(node)
    end
rescue Exception => ex
    puts ex.message
    puts ex.backtrace.join("\n")
    puts "----------------------------" 
    puts "Problem loading nodes file \n"
end
