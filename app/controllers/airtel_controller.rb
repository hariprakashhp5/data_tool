class AirtelController < ApplicationController

	#before_filter :initialize_variable, :only => [:list, :cate]


def extractor_type
	@region_link=Prlink.where("operator_id=? and region_id=?",params[:operator_id],params[:region_id]).pluck("link1").first
	
	if params[:operator_id] == "1"
		airtel_extractor
	elsif params[:operator_id] == "2"
		aircel_extractor
	elsif params[:operator_id] == "3"
		vodafone_extractor
	elsif params[:operator_id] == "4"
		idea_extractor
  elsif params[:operator_id] == "10"
    uninor_extractor
	end
end

def index
	@airtels = Pack.where("operator_id=? and region_id=? and connection_type=? and pack_type=?",
							params[:operator_id],params[:region_id],params[:connection_type],params[:pack_type])

end


def airtel_extractor
agent=Mechanize.new
@page=agent.get (@region_link)
@page.search('#tabs-1 tr').each do |pack|
	@price = pack.search('td[1]').text.strip
     @offer = pack.search('td[2]').text.strip
     @validity = pack.search('td[5]').text.strip
     #@validity= temp_val.scan(/\d+/).first.to_i
     @name = pack.search('td[6]').text.strip

     if @price.to_i > 9
     update_database
 	 end
end
redirect_to '/airtel'

end

def idea_extractor
agent=Mechanize.new
puts params[:pack_type]
if params[:pack_type] == "1"
base_url="http://www.ideacellular.com/customer/prepaid/recharge-offers/"
 add = ["extra-talktime-vouchers", "full-talktime-vouchers", "topup-vouchers", "sms-tariff-vouchers",
             "isd-special-tariff-vouchers","combo-vouchers", "i2i-special-tariff-vouchers", "local-special-tariff-vouchers",
              "national-special-tariff-vouchers", "std-special-tariff-vouchers", "roaming-special-tariff-vouchers"]
              add.each do  |type| 
	r_link = base_url+type+"/"+@region_link
	puts "Extracting from==#{r_link}"

	page=agent.get(r_link)

	a= page.search('.planDetails').text.strip
	headings= a.scan(/(?:mrp|talktime|validity|tariff|tariffValidity|mode)='[\p{Print}]+'/)

	hash = headings.map{ |s|
      str, val = s.split('=')
      [str, val.delete("'")]
      }.each_with_object(Hash.new { |h, k| h[k] = [] }){ |(str, val), h| h[str] << val }

      n = 0
      hash['mrp'].each do
      @name = type
      if ["extra-talktime-vouchers", "full-talktime-vouchers", "topup-vouchers"].any? {|n| type.include? n} then @name = "Top-up" end
      if ["sms-tariff-vouchers"].any? {|n| type.include? n} then @name = "SMS" end   
      if ["isd-special-tariff-vouchers"].any? {|n| type.include? n} then @name = "ISD" end  
      if ["combo-vouchers","i2i-special-tariff-vouchers","local-special-tariff-vouchers",
      			"national-special-tariff-vouchers","std-special-tariff-vouchers"].any? {|n| type.include? n} then @name = "Rate Cutters" end   
      if ["roaming-special-tariff-vouchers"].any? {|n| type.include? n} then @name = "Roaming-STV" end   
      @price= hash['mrp'][n]
      @offering= hash['talktime'][n] || hash['tariff'][n]
      @validity= hash['validity'][n] || hash['tariffValidity'][n]
   
     
      update_database
      n+=1
      end
   end

   			base_url="http://www.ideacellular.com/mobile-internet/"
			add= ["3g/prepaid-data", "2g/prepaid-data"]
			puts "entered datacard"
			add.each do |type|
			  r_link = base_url+type+"/"+@region_link
    	    puts "Extracting from==#{r_link}"
    
    	    agent = Mechanize.new
    	    page = agent.get(r_link) 
    	    a= page.search('#secondColumn').text.strip
    	    headings= a.scan(/(?:mrp|benefit|validity|overage|fup|activation)='[^']+'/)
     	   hash = headings.map{ |s|
     	   str, val = s.split('=')
     	   [str, val.delete("'")]
     	   }.each_with_object(Hash.new { |h, k| h[k] = [] }){ |(str, val), h| h[str] << val }

       	 n = 0
       	 hash['mrp'].each do
       	 @name = type
       	 if ["3g/prepaid-data"].any? {|n| type.include? n} then @name = "3G Mobile" end
       	 if ["3g/prepaid-netsetter"].any? {|n| type.include? n} then @name = "3G Datacard" end
       	 if ["2g/prepaid-data"].any? {|n| type.include? n} then @name = "2G Mobile" end
        
        
       	 @price= hash['mrp'][n].gsub('&amp;', '&')
       	 puts "price=====#{@price}"
       	 @offering= hash['benefit'][n].gsub('&amp;', '&')
       	 puts "offering=====#{@offering}"
       	 @validity= hash['validity'][n].gsub('&amp;', '&')
       	 puts "validity=====#{@validity}"
       	 update_database
        n+=1
      end
  end

elsif params[:pack_type] == "0"
	base_url="http://www.ideacellular.com/mobile-internet/"
	add= ["3g/prepaid-netsetter"]
	puts "entered datacard"
	add.each do |type|
	  r_link = base_url+type+"/"+@region_link
        puts "Extracting from==#{r_link}"
    
        agent = Mechanize.new
        page = agent.get(r_link) 
        a= page.search('#secondColumn').text.strip
        headings= a.scan(/(?:mrp|benefit|validity|overage|fup|activation)='[^']+'/)
        hash = headings.map{ |s|
        str, val = s.split('=')
        [str, val.delete("'")]
        }.each_with_object(Hash.new { |h, k| h[k] = [] }){ |(str, val), h| h[str] << val }

        n = 0
        hash['mrp'].each do
        @name = type
        if ["3g/prepaid-data"].any? {|n| type.include? n} then @name = "3G Mobile" end
        if ["3g/prepaid-netsetter"].any? {|n| type.include? n} then @name = "3G Datacard" end
        if ["2g/prepaid-data"].any? {|n| type.include? n} then @name = "2G Mobile" end
        
        
        @price= hash['mrp'][n].gsub('&amp;', '&')
        puts "price=====#{@price}"
        @offering= hash['benefit'][n].gsub('&amp;', '&')
        puts "offering=====#{@offering}"
        @validity= hash['validity'][n].gsub('&amp;', '&')
        puts "validity=====#{@validity}"
        update_database
        n+=1
      end
  end

else
	puts "nothing"
end

   redirect_to '/packs'
end


def uninor_extractor
  driver = Selenium::WebDriver.for :firefox
  arr=["exclusive-offer","extra-talktime","full-talktime","regular-recharge"]
  arr.each do |type|
  driver.navigate.to "https://www.telenor.in/"+@region_link+"/topup/"+type
  eo = driver.find_element(:id, 'mycustomscroll')

  temp=eo.text.strip


  q=temp.split('`')
q.each do |p|
x=p.split(" ")
@price=x[0]
@offer=x[1]
@validity="Lifetime"
if @price != nil
update_database
end
end
end
redirect_to '/airtel'

end

def vodafone_extractor
end


def delete_packs
	@packs = Pack.where("operator_id=? and region_id=? and connection_type=? and pack_type=?",
							params[:operator_id],params[:region_id],params[:connection_type],params[:pack_type])
	if @packs.delete_all
		redirect_to '/packs'
	end
end

end
