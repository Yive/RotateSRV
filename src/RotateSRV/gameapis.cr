require "cossack"
require "json"

module RotateSRV
  class GameAPIs
    # Adds each line from "domains.txt" in each domain folder to gameapi's database.
    def self.add_domains_to_database(path : String) : Bool
      domains = File.read_lines("#{path}/domains.txt")
      if domains.nil?
        return false
      end
      puts "#{RotateSRV::Colours.green}## Adding domains to database. ###{RotateSRV::Colours.reset}"
      domains.each do |domain|
        if domain.nil?
          next
        end
        response = Cossack.get("https://use.gameapis.net/mc/extra/blockedservers/check/#{domain}")
        if response.status == 200
          puts "#{domain} added to database"
        else
          puts "Unable to add #{domain} to database"
        end
      end
      return true
    end

    # Checks the database at gameapis.net
    def self.check_database(path : String) : Bool
      current, domains = File.read_lines("#{path}/current.txt"), File.read_lines("#{path}/domains.txt")
      remake = ""
      puts "#{RotateSRV::Colours.green}## Checking if any domains in the domains.txt file are blacklisted. ###{RotateSRV::Colours.reset}"
      domains.each do |domain|
        if domain.nil?
          next
        end
        response = Cossack.get("https://use.gameapis.net/mc/extra/blockedservers/check/#{domain}")
        json = JSON.parse(response.body)
        json["#{domain}"].each do |check|
          if check["domain"] == domain
            if check["blocked"] == true
              puts "#{domain}: blacklisted"
              domains.delete(domain)
            else
              puts "#{domain}: not blacklisted"
            end
          else
            if check["blocked"] == true
              puts "#{check["domain"]}: wildcard blacklist detected"
              domains.delete(domain)
            else
              puts "#{check["domain"]}: no wildcard blacklist detected"
            end
          end
        end
      end
      domains.each do |domain|
        remake = remake + "#{domain}\n"
      end
      File.write("#{path}/domains.txt", remake)
      remake = ""
      puts "#{RotateSRV::Colours.green}## Checking if current target is blacklisted. ###{RotateSRV::Colours.reset}"
      currentResponse = Cossack.get("https://use.gameapis.net/mc/extra/blockedservers/check/#{current[0]}")
      currentResponseJson = JSON.parse(currentResponse.body)
      currentResponseJson["#{current[0]}"].each do |check|
        if check["domain"] == current[0]
          if check["blocked"] == true
            puts "#{current[0]}: blacklisted"
            return true
          else
            puts "#{current[0]}: not blacklisted"
          end
        else
          if check["blocked"] == true
            puts "#{check["domain"]}: wildcard blacklist detected"
            return true
          else
            puts "#{check["domain"]}: not blacklisted"
          end
        end
      end
      return false
    end
  end
end