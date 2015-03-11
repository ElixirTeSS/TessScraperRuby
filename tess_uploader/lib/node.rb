class Node
  attr_accessor :title, :name, :country_code, :description, :id, :home_page, :image_url, :twitter,
                :tec, :tec_email, :trc, :trc_email, :hon, :hon_email

  def initialize(title,name,country_code,description=nil,home_page=nil,image_url=nil, twitter=nil,
                 tec_name=nil, tec_email=nil,
                 trc_name=nil, trc_email=nil, 
                 hon_name=nil, hon_email=nil)
    @type = 'node'
    @title = title || nil
    @name = name || nil
    @country_code = country_code || nil
    @description = description
    @home_page = home_page
    @image_url = image_url
    @twitter = twitter
    @trc = trc_name
    @trc_email = trc_email
    @tec = tec_name
    @tec_email = tec_email
    @hon = hon_name
    @hon_email = hon_email
  end

  def update_id(id)
    @id = id    
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
