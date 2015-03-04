class Organisation
  attr_accessor :title, :name, :description, :image_url

  def initialize(title,name,description,image_url)
    @title = title || nil
    @name = name || nil
    @description = description || nil
    @image_url = image_url || nil
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