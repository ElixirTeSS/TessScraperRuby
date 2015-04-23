require 'tess_uploader'
require 'yaml'  

def jsonify(field, list)
    unless list[field].nil? || list[field].empty?
        hash_list = []
        list[field].each do |item|
            details = {}
            name, details = item
            details[:name] = name
            hash_list << details
        end
    end  
    return {field => hash_list}.to_json || nil
end    

begin
    nodes = YAML.load_file('nodes.yml')
    nodes.each do |node| 
        title, info = node
        name = title.downcase.gsub(' ', '-')
        staff_members = jsonify('staff', info)
        member_institutions = jsonify('institutions', info)
        
        node = Node.new(title, name, 
                        info['country_code'],
                        info['member_status'],
                        info['description'],
                        staff_members, member_institutions,
                        info['home_page'], info['twitter'],
                        info['training_coordinator']['name'], 
                        info['training_coordinator']['email'],
                        info['training_coordinator']['image'],
                        info['carousel_image_1'],
                        info['carousel_image_2'],
                        info['carousel_image_3'])
       node = Uploader.create_or_update_node(node)
    end
rescue Exception => ex
    puts ex.message
    puts ex.backtrace.join("\n")
    puts "----------------------------" 
    puts "Problem loading nodes file \n"
end
