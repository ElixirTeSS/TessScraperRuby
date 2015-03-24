class Organisation
  attr_accessor :title, :name, :description, :image_url, :homepage, :node_id

  def initialize(title,name,description,image_url,homepage,node_id=nil)
    @title = title || nil
    @name = name || nil
    @description = description || nil
    @image_url = image_url || nil
    @homepage = homepage || nil
    @node_id = node_id || ''
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
