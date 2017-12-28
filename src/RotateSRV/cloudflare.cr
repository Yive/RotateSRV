require "cossack"
require "json"

module RotateSRV
  class Cloudflare
    # Grabs information about the SRV domain/subdomain.
    def self.get_cloudflare_domain_information(zone : String, email : String, key : String, domain : String) : JSON::Any
      puts "#{RotateSRV::Colours.green}## Grabbing #{domain}'s information from cloudflare. ###{RotateSRV::Colours.reset}"
      cossack = Cossack::Client.new do |client|
        client.headers["X-Auth-Email"] = "#{email}"
        client.headers["X-Auth-Key"] = "#{key}"
        client.headers["Content-Type"] = "application/json"
      end
      cloudflare = cossack.get("https://api.cloudflare.com/client/v4/zones/#{zone}/dns_records?type=SRV&name=_minecraft._tcp.#{domain}")
      cloudflareJson = JSON.parse(cloudflare.body)
      if cloudflareJson["success"].as_bool == false
        puts "#{RotateSRV::Colours.red}Cloudflare error detected while grabbing domain information:#{RotateSRV::Colours.reset}"
        puts "#{RotateSRV::Colours.red}=================#{RotateSRV::Colours.reset}"
        puts cloudflareJson.to_pretty_json
        puts "#{RotateSRV::Colours.red}=================#{RotateSRV::Colours.reset}"
        puts "Contact Yive with the json between the lines if this ever happens."
        puts "If you decide to post this as an issue on github, make sure you remove the \"id\" & \"zone_id\" entires before posting."
      end
      return cloudflareJson
    end

    # Sets the SRV domain/subdomain record to it's new target.
    def self.updateCloudflareDomains(zone : String, email : String, key : String, domainID : String, domain : String, target : String, port : String, path : String) : Bool
      puts "#{RotateSRV::Colours.green}## Updating #{domain}'s SRV target to #{target}. ###{RotateSRV::Colours.reset}"
      requestJson = JSON.build do |json|
        json.object do
          json.field "type", "SRV"
          json.field "ttl", 120
          json.field "data" do
            json.object do
              json.field "name", domain
              json.field "weight", "5"
              json.field "priority", "0"
              json.field "target", target
              json.field "service", "_minecraft"
              json.field "proto", "_tcp"
              json.field "port", port.to_i
            end
          end
        end
      end
      cossack = Cossack::Client.new do |client|
        client.headers["X-Auth-Email"] = "#{email}"
        client.headers["X-Auth-Key"] = "#{key}"
        client.headers["Content-Type"] = "application/json"
      end
      cloudflare = cossack.put("https://api.cloudflare.com/client/v4/zones/#{zone}/dns_records/#{domainID}", requestJson)
      cloudflareJson = JSON.parse(cloudflare.body)
      if cloudflareJson["success"].as_bool == false
        puts "#{RotateSRV::Colours.red}Cloudflare error detected while updating domain information:#{RotateSRV::Colours.reset}"
        puts "#{RotateSRV::Colours.red}=================#{RotateSRV::Colours.reset}"
        puts cloudflareJson.to_pretty_json
        puts "#{RotateSRV::Colours.red}=================#{RotateSRV::Colours.reset}"
        puts "Contact Yive with the json between the lines if this ever happens."
        puts "If you decide to post this as an issue on github, make sure you remove the \"id\" & \"zone_id\" entires before posting."
        return false
      end
      remake = ""
      domains = File.read_lines("#{path}/domains.txt")
      domains.delete(target)
      File.write("#{path}/current.txt", target)
      domains.each do |domain|
        remake = remake + "#{domain}\n"
      end
      File.write("#{path}/domains.txt", remake)
      return true
    end
  end
end