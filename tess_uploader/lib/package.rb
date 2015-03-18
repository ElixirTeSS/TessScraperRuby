# Note: This is a Training Package in the TeSS vernacular. Not a dataset package in CKANs

class Package
  attr_accessor :title, :name, :description, :image_url

  def initialize(title,name,description=nil,image_url=nil)
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
