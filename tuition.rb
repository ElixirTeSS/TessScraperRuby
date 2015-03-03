require 'json'

module Tuition

  # Compare a TuitionUnit or subclass thereof with some data already
  # in the TeSS site.
  def compare(current,tess)
    dont_change = %w(id name created last_modified last_update package_id tags owner_org)
    newdata = tess
    changed = false
    current.each_key do |key|
      if key.nil? or dont_change.select {|k,v| k == key}
        next
      end
      # Format can be created in lower case but comes back from the server in upper case...
      if key == 'format'
        if current[key].lower == tess[key].lower
          newdata[key] = current[key]
          changed = true
        end
      elsif current[key].class == 'Array'
        if current[key] != eval(tess[key]) # convert to array for the comparison
          newdata[key] = current[key]
          changed = true
        end
      else
        if current[key] == tess[key]
          newdata[key] = current[key]
          changed = true
        end
      end
    end
    if changed
      return newdata
    else
      return nil
    end
  end

  # Don't use this directly, create Tutorial or FaceToFace instances.
  class TuitionUnit
    attr_accessor :name, :title, :url, :notes, :tags, :package_id, :parent_id, :resources, :doi, :created,
                  :last_modified, :format, :keywords, :difficulty, :owning_org, :audience

    def initialize
      @name = nil
      @title = nil
      @url = nil
      @notes = nil
      @tags = []
      @package_id = nil # CKAN package ID
      @parent_id = nil # id of preceeding tutorial/class &c.
      @resources = []
      @doi = nil
      @created = nil
      @last_modified = nil
      @format = nil
      @keywords = []
      @difficulty = nil
      @owning_org = nil # CKAN owning organisation
      @audience = []
    end

    def dump
      hash = {}
      self.instance_variables.each do |var|
        varname = var.to_s.gsub(/@/,'')
        hash[varname] = self.instance_variable_get var
      end
      return hash
    end

    def dump_json
      return self.dump.to_json
    end

    def set_name(owner_org,item_name)
        @name = owner_org + '-' + item_name.downcase.gsub(/[^0-9a-z_-]/,'_')[0..99]
    end

  end

  # An on-line tutorial.
  class Tutorial < TuitionUnit
    attr_accessor :author

    def initialize
      super
      @author = nil
    end

  end

  # A course held in person somewhere.
  class FaceToFace < TuitionUnit
    attr_accessor :organisers, :dates

    def initialize
      super
      @organisers = []
      @dates = []
    end
  end

end