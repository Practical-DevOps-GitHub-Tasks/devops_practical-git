require 'net/http'
require 'uri'
require 'json'
  class GithubApi

    @@repo_uri =  ''
    @@token = ''
    def get(url)
      uri = URI.parse("#{@@repo_uri}#{"/#{url}" if url != ''}")
      request = Net::HTTP::Get.new(uri)
      request["Accept"] = "application/vnd.github+json"
      request["Authorization"] = "Bearer #{@@token}"
      request["X-Github-Api-Version"] = "2022-11-28"

      req_options = {
        use_ssl: uri.scheme == "https",
      }

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end
    end

    def branch_protected?(json_obj, branch_name)
      branches = JSON.parse(json_obj).select{|element| element["name"] == branch_name}
      return "Branch with #{branch_name} doesn't exist" if branches.empty?
      branches[0]["protected"]
    end

    def branch_exist?(json_obj, branch_name)
      !JSON.parse(json_obj).select{|element| element["name"] == branch_name}.empty?
    end

    def branches(json_obj)
      JSON.parse(json_obj)
    end

    def branch(json_obj, branch_name)
      JSON.parse(json_obj).select{|element| element["name"] == branch_name}
    end

    def default_branch(json_obj)
      JSON.parse(json_obj)["default_branch"]
    end

  end


