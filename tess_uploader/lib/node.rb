class Node
  attr_accessor :title, :name, :country_code, :member_status, :description, :staff, :institutions,
                :id, :home_page, :twitter, :trc, :trc_email, :trc_image, 
                :carousel_image_1, :carousel_image_2, :carousel_image_3

  def initialize(title, name, country_code, member_status, description=nil, staff=nil, institutions=nil,
                home_page=nil, twitter=nil, trc=nil, trc_email=nil, trc_image=nil, 
                carousel_image_1=nil, carousel_image_2=nil, carousel_image_3=nil)

    @type = 'node'
    @title = title || nil
    @name = name || nil
    @country_code = country_code || nil
    @member_status = member_status || 'Interested'
    @description = description
    @home_page = home_page
    @twitter = twitter
    @trc = trc
    @trc_email = trc_email
    @trc_image = trc_image
    @staff = staff
    @institutions = institutions
    @carousel_image_1 = carousel_image_1
    @carousel_image_2 = carousel_image_2
    @carousel_image_3 = carousel_image_3
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
