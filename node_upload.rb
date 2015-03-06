require 'tess_uploader'
require 'yaml'  

class Node
  attr_accessor :title, :name, :country_code, :description, :image_url, :tec, :trc, :hon

  def initialize(title,name,country_code,description=nil,image_url=nil,tec=nil,trc=nil,hon=nil)
    @type = 'node'
    @title = title || nil
    @name = name || nil
    @country_code = country_code || nil
    @description = description
    @trc = trc
    @tec = tec
    @hon = hon
    @image_url = image_url
  end

  def dump
    hash = {}
    self.instance_variables.each do |var|
      varname = var.to_s.gsub(/@/,'')
      hash[varname] = self.instance_variable_get var
    end
    return hash
  end

  def to_json
    return self.dump.to_json
  end

  def [](var)
    return self.send(var)
  end
end

begin
    nodes = YAML.load_file('nodes.yml')
rescue Exception
    print "Problem loading nodes file"
end

nodes.each do |node| 
    title, info = node
    name = title.downcase
    node = Node.new(title, name, \
                    info['country_code'], info['description'], \
                    info['image_url'], info['tec'], info['trc'], info['hon'])
    Uploader.create_node(node)
end


