require 'rubygems' 
require 'json' #Useed to parse JSON
require 'rest-client' #Rest Client used for making Rest calls
require 'uri' #used for uri validator
require 'resolv' #used for IP address validator
 
 #Method used for validating IOCs in honeypot.json file
 def validator(a)
	File.open('/Users/sumit/Documents/Zendesk-challenge/honeypot.json').each_line do |line|
 	 	line.chomp!.downcase!
	  	if line.match(/#{a}/)
		  	json = JSON.parse(line)
		  	newJson = JSON.parse(json["payload"])
		  	puts "Information for Victim IP: #{newJson["victimip"]}"
		  	puts "Attacker IP: #{newJson["attackerip"]}"
		  	puts "Connection Type: #{newJson["connectiontype"]}"
		  	puts "Source: Honeypot"
		  	puts "Time stamp #{json["timestamp"]}"
		  	puts "\n"
	  	end
	 end
end

#Takes multiple IOCs as arguments and look up for information related to IOCs
ARGV.each do |a|
	case a
	when Resolv::IPv4::Regex
  		puts "It's a valid IPv4 address."
  		validator(a) #Checks for victim's IP4 in honeypot.json
		inputUrl = "http://isc.sans.edu/api/ip/" + a + "/handler?json" #string concatenation to make REST call
		Response = RestClient.get inputUrl #checks for IPs in other APIs 
		puts Response
	when Resolv::IPv6::Regex
  		puts "It's a valid IPv6 address." #checks for IP6 in honeypot.json
  		validator(a)
	else
		puts "check for url in other APIs like virustotal" 
  		urlArray = URI.extract(a, ['http', 'https']) #url validator and extractor from Argument. returns an array 
		urlArray.each do |x|
			# HTTP post call to scan URl in virustotal database and generate report
			RestClient.post 'https://www.virustotal.com/vtapi/v2/url/scan', :url => a, :apikey => "ed2011b9a973a2c426cfd3c955cbdca8292695fd86396698d44d0d347fdbbe0d"
			# HTTP post call to print generated report from previous REST call
			Response = RestClient.post 'http://www.virustotal.com/vtapi/v2/url/report', :resource => a, :apikey => "ed2011b9a973a2c426cfd3c955cbdca8292695fd86396698d44d0d347fdbbe0d"
			puts Response
		end
		puts "\n"
		puts "Check other IOCs in Honeypot JSON" # Check for other IOCs like port, source in heneypot.json
		validator(a)
	end
	
end
