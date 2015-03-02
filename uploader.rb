require 'inifile'
require 'net/http'

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
      puts "Trying URL: " + url

      auth = conf['auth']
      if auth.nil?
          puts "API string missing!"
          return
      end

      uri = URI(url)
      req = Net::HTTP::Post.new(uri, initheader = {'Content-Type' =>'application/json'})
      req.body = data
      req.add_field('Authorization', auth)
      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end

      unless res.code == 200
        puts "Upload failed: #{res.code}"
        return {}
      end

      # package_create returns the created package as its result.
      created_package = response.body['result']
      puts created_package
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

    def self.check_dataset(dataset)

    end

    def self.update_dataset(data)

    end

    def self.update_resource(data)

    end

    def self.create_or_update(data)
      # Temporary placeholder code
      self.create_dataset(data)
      self.create_resource(data)
    end


end