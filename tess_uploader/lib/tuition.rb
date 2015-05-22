require 'json'

module Tuition

  # Compare a TuitionUnit or subclass thereof with some data already
  # in the TeSS site.
  def self.compare(current,tess)
    debug = false
    # TODO: Tags need to be fixed...
    dont_change = %w(id name created last_modified last_update package_id owner_org keywords audience)
    newdata = tess
    changed = false
    # Current is an instance of Tuition, and newdata is a hash
    current.instance_variables.each do |var|
      key = var.to_s.gsub(/@/,'')
      #puts "Current: #{current[key]}"
      #puts "TeSS: #{tess[key]}"
      if key.nil? or dont_change.select {|k,v| k == key}.length > 0
        #puts "Skipping..."
        print '.'
        next
      end
      # Format can be created in lower case but comes back from the server in upper case...
      if key == 'format'
        if !current[key].nil? and !tess[key].nil?
          if current[key].downcase != tess[key].downcase
            #puts "CHANGE(1) #{newdata[key]}, #{current[key]}"
            newdata[key] = current[key]
            changed = true
          end
        end
      elsif current[key].class == 'Array'
        if current[key] != eval(tess[key]) # convert to array for the comparison
          #puts "CHANGE(2) #{newdata[key]}, #{current[key]}"
          newdata[key] = current[key]
          changed = true
        end
      else
        if current[key] != tess[key]
          #puts "KEY: #{key}"
          #puts "CHANGE(3) #{newdata[key]}, #{current[key]}"
          newdata[key] = current[key]
          changed = true
        end
      end
    end
    # Something funny is going on in those comparisons above. It seemed to affect the Python version as well.
    # Often, something is marked as changed when it hasn't been...
    if debug
      puts "Original: #{tess}"
      puts "Changed: #{newdata}"
    end
    if changed
      return newdata
    else
      return {}
    end
  end

  # Don't use this directly, create Tutorial or FaceToFace instances.
  class TuitionUnit
    attr_accessor :name, :title, :url, :notes, :tags, :package_id, :parent_id, :resources, :doi, :created,
                  :last_modified, :format, :keywords, :difficulty, :owner_org, :audience, :description

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
      @owner_org = nil # CKAN owning organisation
      @audience = []
      @description = nil
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

    def set_name(owner_org,item_name)
        @name = (owner_org + '-' + item_name.downcase.gsub(/[^0-9a-z_-]/,'_').gsub(/[_]+/,'_'))[0...99]
    end

    def [](var)
      return self.send(var)
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