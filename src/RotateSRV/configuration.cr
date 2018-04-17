require "dotenv"

module RotateSRV
  class Configuration
    def self.generate_example : Bool
      if Dir.exists?("./domains-example")
          puts "Example folder is being deleted & regenerated. Hope you didn't put anything important in there."
          Dir.glob("./domains-example/mc.example.com/*").each do |glob|
            if glob.nil?
              next
            end
            File.delete(glob)
          end
          Dir.rmdir("./domains-example/mc.example.com")
          Dir.rmdir("./domains-example")
      end
      Dir.mkdir_p("./domains-example/mc.example.com")
      File.write("./domains-example/mc.example.com/.env", "# API key for Cloudflare.\nCLOUDFLARE-KEY=\n# Zone ID for your domain at Cloudflare.\nCLOUDFLARE-ZONE=\n# The email for the account that has your domain on it.\nCLOUDFLARE-EMAIL=\n\n# The sub-domain/domain that your players join through. (MUST BE AN SRV RECORD)\nDOMAIN-NAME=mc.example.com\n# The port that your SRV record is pointing to.\nPORT=25565\n# Instead of having a domains.txt for each domain, when a domain has this set to true, the program will use the domains.txt from inside of the folder called multiple.\nMULTI=false")
      File.write("./domains-example/mc.example.com/current.txt", "example.ddns.net")
      File.write("./domains-example/mc.example.com/domains.txt", "example1.ddns.net\nexample2.ddns.net")
      return true
    end

    # Checks if config files exist.
    def self.check_configs : Bool
      if !Dir.exists?("./domains")
        puts "Domains folder doesn't exist."
        Dir.mkdir("./domains")
        Configuration.generate_example
        return false
      end
      if Dir.empty?("./domains")
        puts "Domains folder is empty."
        puts "Remember to read the readme for this tool's github repo."
        Configuration.generate_example
        return false
      end
      return true
    end

    # Grabs enviorment settings in each domain folder.
    def self.check_settings(path : String) : Bool
      settings = Dotenv.load "#{path}/.env"

      if settings["CLOUDFLARE-KEY"].empty?
        puts "CLOUDFLARE-KEY empty in #{path}"
        return false
      elsif settings["CLOUDFLARE-ZONE"].empty?
        puts "CLOUDFLARE-ZONE empty in #{path}"
        return false
      elsif settings["CLOUDFLARE-EMAIL"].empty?
        puts "CLOUDFLARE-EMAIL empty in #{path}"
        return false
      elsif settings["DOMAIN-NAME"].empty?
        puts "DOMAIN-NAME empty in #{path}"
        return false
      elsif settings["PORT"].empty?
        puts "PORT empty in #{path}"
        return false
      end

      return true
    end

    # Checks if the domains file is empty.
    def self.check_domains(path : String) : Bool
      if File.empty?("#{path}/domains.txt")
        puts "#{RotateSRV::Colours.red}domains.txt in #{path} is empty. The SRV record for this domain cannot have it's target changed. Please top it up with new domains.#{RotateSRV::Colours.reset}"
        return false
      end
      return true
    end

    # Checks if the current file is empty.
    def self.check_current(path : String) : Bool
      if File.empty?("#{path}/current.txt")
        puts "#{RotateSRV::Colours.red}current.txt in #{path} is empty. To decrease the amount of API calls to Cloudflare, this tool doesn't grab the current SRV's target. Please set it to the current SRV's target.#{RotateSRV::Colours.reset}"
        return false
      end
      return true
    end
  end
end