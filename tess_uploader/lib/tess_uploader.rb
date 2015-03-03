

class TessUploader
  # Placeholder class.
  require 'inifile'
  require 'net/http'
  require 'organisation'
  require 'tuition'
end


module Uploader
  # The config file is a standard format of .ini file, which only has one
  # section ('Main') at present.
  def self.get_config
    host, port, protocol, auth = nil
    myini = IniFile.load('uploader_config.txt')

    unless myini
      puts "Can't open config file!"
      return nil
    end

    myini.each_section do |section|
      if section == 'Main'
        host = myini[section]['host']
        port = myini[section]['port']
        protocol = myini[section]['protocol']
        auth = myini[section]['auth']
      end
    end

    return {
        'host' => host,
        'port' => port,
        'protocol' => protocol,
        'auth' => auth
    }

  end

  # This method is used by several futher ones below, each of which have varying URLs depending
  # on whether they create packages, datasets &c.
  def self.do_upload(data,url,conf)
    # process data to json for uploading
    puts "Trying URL: #{url}"

    auth = conf['auth']
    if auth.nil?
      puts "API string missing!"
      return
    end

    uri = URI(url)
    req = Net::HTTP::Post.new(uri, initheader = {'Content-Type' =>'application/json'})
    req.body = data.dump_json
    req.add_field('Authorization', auth)
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end

    unless res.code == '200'
      puts "Upload failed: #{res.code}"
      return {}
    end

    # package_create returns the created package as its result.
    created_package = JSON.parse(res.body)['result']
    return created_package
  end

  def self.create_dataset(data)
    conf = self.get_config
    action = '/api/3/action/package_create'
    url = conf['protocol'] + '://' + conf['host'] + ':' + conf['port'].to_s + action
    return self.do_upload(data,url,conf)
  end

  def self.create_resource(data)
    conf = self.get_config
    action = '/api/3/action/resource_create'
    url = conf['protocol'] + '://' + conf['host'] + ':' + conf['port'].to_s + action
    return self.do_upload(data,url,conf)
  end

  def self.create_organisation(data)
    conf = self.get_config
    action = '/api/3/action/organization_create'
    url = conf['protocol'] + '://' + conf['host'] + ':' + conf['port'].to_s + action
    return self.do_upload(data,url,conf)
  end

  def self.check_dataset(data)
    conf = self.get_config
    action = '/api/3/action/package_show?id='
    url = conf['protocol'] + '://' + conf['host'] + ':' + conf['port'].to_s + action + data.name
    return self.do_check(data,url,conf)
  end

  def self.check_organistion(data)
    conf = self.get_config
    action = '/api/3/action/organization_show?id='
    url = conf['protocol'] + '://' + conf['host'] + ':' + conf['port'].to_s + action + data.name
    return self.do_check(data,url,conf)
  end

  def self.do_check(data,url,conf)
    auth = conf['auth']
    if auth.nil?
      return nil
    end
    uri = URI(url)
    puts "URL: #{url}"
    req = Net::HTTP::Post.new(uri, initheader = {'Content-Type' =>'application/json'})
    req.body = data.dump_json
    req.add_field('Authorization', auth)
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    unless res.code == '200'
      puts "Check failed: #{res.code}"
      return nil
    end
    checked_result = JSON.parse(res.body)['result']
    #puts "CHECKED: #{checked_result}"
    if checked_result
      return checked_result
    else
      return nil
    end
  end

  def self.update_dataset(data)
    conf = self.get_config
    action = '/api/3/action/package_update'
    url = conf['protocol'] + '://' + conf['host'] + ':' + conf['port'].to_s + action
    return self.do_upload(data,url,conf)
  end

  def self.update_resource(data)
    conf = self.get_config
    action = '/api/3/action/resource_update'
    url = conf['protocol'] + '://' + conf['host'] + ':' + conf['port'].to_s + action
    return self.do_upload(data,url,conf)
  end

  def self.create_or_update(data)
    data_exists = self.check_dataset(data)
    #puts "EXISTS: #{data_exists}"
    if !data_exists.nil?
      # This has already been added to TeSS.
      changes = Tuition.compare(data,data_exists)
      if !changes.nil?
        # There has been some change to the data and an update may be required.
        puts 'DATASET: Something has changed.'
        update = self.update_dataset(data)
        if !update.nil?
          puts 'Package updated.'
          # Update the resources for each dataset.
          data_exists['resources'].each do |res|
            res_changes = Tuition.compare(data,res)
            if !res_changes.nil?
              res_updated = self.update_resource(res_changes)
              if !res_updated.nil?
                puts 'Resource updated.'
              end
            end
          end
        end
      else
        puts 'DATASET: No change.'
      end
    else
      # This is not present on TeSS and should be added.
      puts 'Creating dataset.'
      dataset = self.create_dataset(data)
      #puts "Dataset: #{dataset}"
      if !dataset.nil?
        data.package_id = dataset['id']
        data.name = data.name + '-link'
        #puts "Preparing to send: #{data.dump_json}"
        resource = self.create_resource(data)
        puts "resource: #{resource}"
        if resource.nil?
          puts 'Resource not created!'
        end
      else
        puts 'Could not create dataset, so no resource created!'
      end
    end

  end

  def self.check_create_organisation(data)
    if self.check_organistion(data).nil?
      if self.create_organisation(data).nil?
        puts "Failed to create organisation #{data.name}."
      else
        puts "Created organisation #{data.name}."
      end
    else
      puts "Organisation #{data.name} already exists."
    end
  end

end
