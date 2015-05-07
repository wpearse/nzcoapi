# Set Version
VERSION = "0.1.0"

require 'httparty'
require 'base64'
require 'time'
require 'nokogiri'
require 'figaro'

module Nzcoapi

	include HTTParty
	include Nokogiri
	include Figaro

    @@server_name = "www.businessdata.govt.nz"
	@@access_key = YAML.load_file("config/application.yml")['nzcoapi_access_key']
	@@secret_key = YAML.load_file("config/application.yml")['nzcoapi_secret_key']
	@@timestamp = Time.now.rfc2822 + " GMT"

    base_uri = "http://" + @@server_name
    format :xml

  	headers "Access" => @@access_key
  	headers 'Accept' => "application/xml"

	def self.search_for_company(string)
		@@timestamp = Time.now.rfc2822 + " GMT"
        @@resource_name = "/data/app/ws/rest/companies/entity/search/v2.0/#{string}"

		stringtosign = "GET" + "\n" + @@server_name + "\n" + @@resource_name + "\n" + @@timestamp + "\n" + @@access_key + "\n" + "application/xml" + "\n"

		headers "Authorization" => @@access_key + ":" + Base64.strict_encode64(OpenSSL::HMAC.digest('sha256', @@secret_key, stringtosign))
		headers "Timestamp" => @@timestamp

		Nokogiri::XML((get(@@resource_name).body), 'UTF-8')
	end

	def self.find_director(string)
		@@timestamp = Time.now.rfc2822 + " GMT"
        @@resource_name = "/data/app/ws/rest/companies/role/search/v1.0/size/200/type/DIR/#{string}"

		stringtosign = "GET" + "\n" + @@server_name + "\n" + @@resource_name + "\n" + @@timestamp + "\n" + @@access_key + "\n" + "application/xml" + "\n"

		headers "Authorization" => @@access_key + ":" + Base64.strict_encode64(OpenSSL::HMAC.digest('sha256', @@secret_key, stringtosign))
		headers "Timestamp" => @@timestamp

		Nokogiri::XML((get(@@resource_name).body), 'UTF-8')
	end

	def self.find_company(id)
		@@timestamp = Time.now.rfc2822 + " GMT"
        @@resource_name = "/data/app/ws/rest/companies/entity/v2.0/#{id}"

		stringtosign = "GET" + "\n" + @@server_name + "\n" + @@resource_name + "\n" + @@timestamp + "\n" + @@access_key + "\n" + "application/xml" + "\n"

		headers "Authorization" => @@access_key + ":" + Base64.strict_encode64(OpenSSL::HMAC.digest('sha256', @@secret_key, stringtosign))
        headers "Timestamp" => @@timestamp

		Nokogiri::XML((get(@@resource_name).body), 'UTF-8')
	end

	def self.tagged(tag)
		retrieve_url get("/#{tag}.json")
	end

end
