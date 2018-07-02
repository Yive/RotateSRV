require "./RotateSRV/*"

module RotateSRV
  puts "#{RotateSRV::Colours.green}RotateSRV Alpha #{VERSION} - SRV rotator for blacklisted Minecraft servers.#{RotateSRV::Colours.reset}\n\n"
  puts "#{RotateSRV::Colours.red}MOJANG'S EULA HAS NO LEGAL FOOTING WHATSOEVER WITH SERVER MONETISATION VIOLATIONS.#{RotateSRV::Colours.reset}"
  puts "#{RotateSRV::Colours.red}MOJANG WILL NEVER TAKE YOU TO COURT FOR BYPASSING THE BLACKLIST.#{RotateSRV::Colours.reset}"
  puts "#{RotateSRV::Colours.red}Only time Mojang would take someone to court is if they're providing a launcher to play Minecraft for free. #{RotateSRV::Colours.reset}\n\n"
  puts "Note: If you try to bypass Mojang's blacklist, they'll never unblacklist you even if you decide to be dumb & be compliant with their EULA again."
  puts "Things that'll cause you be permanently blacklisted:"
  puts "- Blocking traffic from Sweden to your store/server.\n- Using an SRV record to bypass the blacklist.\n- Hiding P2W perks.\n\n"
  if !RotateSRV::Configuration.check_configs
    exit
  end
  domain_folders = Dir.glob("./domains/*")
  while true
    domain_folders.each do |domain|
      if !RotateSRV::Configuration.check_settings(domain)
        next
      end
      settings = Dotenv.load "#{domain}/.env"
      if !RotateSRV::Configuration.check_current(domain)
        next
      end
      if !RotateSRV::Configuration.check_domains(domain)
        next
      end
      RotateSRV::GameAPIs.add_domains_to_database(domain)
      if !RotateSRV::GameAPIs.check_database(domain)
        next
      end
      if !RotateSRV::Configuration.check_current(domain)
        next
      end
      cloudflare = RotateSRV::Cloudflare.get_cloudflare_domain_information(settings["CLOUDFLARE-ZONE"], settings["CLOUDFLARE-EMAIL"], settings["CLOUDFLARE-KEY"], settings["DOMAIN-NAME"])
      if cloudflare["success"].as_bool == false
        next
      end
      domains = File.read_lines("#{domain}/domains.txt")
      begin
        RotateSRV::Cloudflare.update_cloudflare_domains(settings["CLOUDFLARE-ZONE"], settings["CLOUDFLARE-EMAIL"], settings["CLOUDFLARE-KEY"], cloudflare["result"][0]["id"].to_s, settings["DOMAIN-NAME"], domains[0], settings["PORT"], domain)
        puts "#{RotateSRV::Colours.green}.#{settings["DOMAIN-NAME"]} has had it's target changed to #{domains[0]}#{RotateSRV::Colours.reset}"
      rescue e
        puts "Error while attempting to update cloudflare."
        puts "CLOUDFLARE-ZONE: #{settings["CLOUDFLARE-ZONE"]}"
        puts "CLOUDFLARE-EMAIL: #{settings["CLOUDFLARE-EMAIL"]}"
        puts "CLOUDFLARE-KEY: #{settings["CLOUDFLARE-KEY"]}"
        puts "Cloudflare Response ID: #{cloudflare["result"][0]["id"]}"
        puts "DOMAIN-NAME: #{settings["DOMAIN-NAME"]}"
        puts "Line 1 of #{domain}domains.txt: #{domains[0]}"
        puts "PORT: #{settings["PORT"]}"
        puts e
      end
    end
    puts "\n" * 2
    puts "#{RotateSRV::Colours.cyan}"
    puts "It's appreciated if you donate to the developer of this tool."
    puts "Bitcoin: 17VvSXnhcNeUcCtnjZCoogNCoi8CGuadWF"
    puts "#{RotateSRV::Colours.reset}"
    puts "\n" * 2
    sleep 60.seconds
  end
end