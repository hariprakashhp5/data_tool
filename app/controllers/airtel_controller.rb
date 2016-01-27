class AirtelController < ApplicationController

	
def extractor_type
	@region_link=Prlink.where("operator_id=? and region_id=?",params[:operator_id],params[:region_id]).pluck("link1").first
	@region_name=Region.where("id=?",params[:region_id]).pluck("name").first
  @operator_name=Operator.where("id=?",params[:operator_id]).pluck("name").first
  puts @region_link
	if params[:operator_id] == "1"
		airtel_extractor
	elsif params[:operator_id] == "2"
		aircel_extractor
	elsif params[:operator_id] == "3"
		vodafone_extractor
	elsif params[:operator_id] == "4"
		idea_extractor
  elsif params[:operator_id] == "6"
    reliance_GSM_CDMA
  elsif params[:operator_id] == "7"
    reliance_GSM_CDMA
  elsif params[:operator_id] == "10"
    uninor_extractor
	end
end

def index
	@airtels = Pack.where("operator_id=? and region_id=? and connection_type=? and pack_type=?",
							params[:operator_id],params[:region_id],params[:connection_type],params[:pack_type])
  @region=Region.where("id=?",params[:region_id]).pluck("name").first
  @operator=Operator.where("id=?",params[:operator_id]).pluck("name").first
  @@temp=@airtels
end

def talk
  # if params[:category] == "Sms"
  #   rr=@@temp.
  @airtels=@@temp.where("caty=?",params[:category])
end

def airtel_extractor
agent=Mechanize.new
@page=agent.get (@region_link)
@page.search('#tabs-1 tr').each do |pack|
	@price = pack.search('td[1]').text.strip
     @offer = pack.search('td[2]').text.strip
     @validity = pack.search('td[5]').text.strip
     @name = pack.search('td[6]').text.strip
      if ["Top-up Recharge", "Full Talk-time Recharge"].any? {|n| @name.include? n} then @caty = "Talktime" end 
      if @name.include?("2G Data Recharge") then @caty = "GPRS" end
      if @name.include?("Special Recharge - STV : Combo") then @caty = "Ratecutters" end
      if ["3G/4G Data Recharge", "3G Data Recharge"].any? {|n| @name.include? n} then @caty = "3G-Data" end 
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
      @name = type.capitalize
      #if ["extra-talktime-vouchers", "full-talktime-vouchers", "topup-vouchers"].any? {|n| type.include? n} then @name = "Top-up" end
      
      @price= hash['mrp'][n]
      @offering= hash['talktime'][n] || hash['tariff'][n]
      @validity= hash['validity'][n] || hash['tariffValidity'][n]
   
     if @price > 9
      update_database
    end
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
       	 if ["2g/prepaid-data"].any? {|n| type.include? n} then @name = "2G Mobile" end
        
        
       	 @price= hash['mrp'][n].gsub('&amp;', '&')
       	 @offering= hash['benefit'][n].gsub('&amp;', '&')
       	 @validity= hash['validity'][n].gsub('&amp;', '&')
          if @price > 9
       	 update_database
        end
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
        @name = "3G Datacard"
        @price= hash['mrp'][n].gsub('&amp;', '&')
        @offering= hash['benefit'][n].gsub('&amp;', '&')
        @validity= hash['validity'][n].gsub('&amp;', '&')
        if @price > 9
        update_database
      end
        n+=1
      end
  end

else
	puts "nothing"
end

   redirect_to '/packs'
end


def uninor_extractor
  headless = Headless.new
  headless.start  
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
@name=type.capitalize
@caty="#{@price} #{type.capitalize} #{@region_name} #{@operator_name}"
if @price.to_i > 9
update_database
end
end
end

arr=["local", "std","value-packs", "internet", "sms", "roaming" ]
arr.each do |type|
driver.navigate.to "https://www.telenor.in/"+@region_link+"/plan/"+type
if driver.find_element(:css, "ul.pack_cat.desktop").text.include?("Other Packs")
driver.find_element(:link, "Other Packs").click
elsif driver.find_element(:css, "ul.pack_cat.desktop").text.include?("Data Packs")
driver.find_element(:link, "Data Packs").click
end
sleep 2
as=driver.find_element(:id,"mCSB_1_container")
plant=as.find_elements(:css, "ul.plan-title")
plant.each do |desc|
@price=desc.find_element(:css, "li.mrp.ng-binding").attribute("textContent").split(" ").join(" ").sub(/`/,'')
@validity=desc.find_element(:css, "li.talktime.ng-binding.ng-scope").attribute("textContent").split(" ").join(" ")
if desc.find_element(:css, "li.benefits").text.include?("More")
@offer=desc.find_element(:css, "li.benefits > span:nth-child(1) > span.plan-popup.ng-binding").attribute("textContent").split(" ").join(" ")
else
@offer=desc.find_element(:css, "li.benefits").attribute("textContent").split(" ").join(" ").sub(/Hide.*/, '')
end
@name="#{@price} #{type.capitalize} #{@region_name} #{@operator_name}"
if type == "internet"
@caty="Data"
elsif type == "sms"
  @caty = "Sms"
else
  @caty="Ratecutters"
end
if @price.to_i > 9
  update_database
end
end
end



driver.navigate.to "https://www.telenor.in/"+@region_link+"/combo-vouchers"
if driver.find_element(:css, "ul.pack_cat").text.include?("Other Packs")
driver.find_element(:link, "Other Packs").click
elsif driver.find_element(:css, "ul.pack_cat").text.include?("Data Packs")
driver.find_element(:link, "Data Packs").click
end
puts "going to sleep"
sleep 2
plant=driver.find_elements(:css, "ul.plan-title.ng-scope")
puts "one"
plant.each do |desc|
@price=desc.find_element(:css, "li.mrp.ng-binding").attribute("textContent").split(" ").join(" ").sub(/`/,'')
@validity=desc.find_element(:css, "li.validity.ng-binding").attribute("textContent").split(" ").join(" ")
if desc.find_element(:css, "li.benefits").text.include?("More")
@offer=desc.find_element(:css, "li.benefits > span:nth-child(1) > span.plan-popup.ng-binding").attribute("textContent").split(" ").join(" ")
else
@offer=desc.find_element(:css, "li.benefits").attribute("textContent").split(" ").join(" ").sub(/Hide.*/, '')
end
@name="#{@price} Combo #{@region_name} #{@operator_name}"
@caty="Combo"
if @price.to_i > 9
  update_database
end
end
driver.close
headless.destroy
redirect_to '/airtel'

end


def reliance_GSM_CDMA
  headless = Headless.new
  headless.start  
  driver = Selenium::WebDriver.for :firefox
  if params[:operator_id] == "6"
    provider_band = "GSM"
    circlevalue = "getCircleValgsm"
    arr=["#topup-gsm","#stv-gsm"]
  elsif params[:operator_id] == "7"
    provider_band = "CDMA"
    circlevalue = "getCircleValcdma"
    arr=["#topup-cdma","#stv-cdma", "#MIP-cdma"]
  end
  driver.navigate.to "http://www.rcom.co.in/Rcom/personal/prepaid/PlansandPacks.html?i=IC"
  puts provider_band
  driver.find_element(:link, provider_band).click
  driver.find_element(:id, circlevalue).find_element(:css,"option[value="+@region_link+"]").click
arr.each do |type|
driver.find_element(:css, type).click
sleep 5
if type == "#topup-gsm"
  location="#plansnpacks_details > div > table.greentable.leftlink1 > tbody > tr"
elsif type =="#stv-gsm"
  location="#plansnpacks_details > div > table:nth-child(1) > tbody > tr"
end
driver.find_elements(:css, location).each do |po|
  c=po.find_element(:css, "td:nth-child(1)") rescue false
  if c!=false
  caty=c.attribute("textContent").split(" ").join(" ")
else
  puts "cate else===#{c}"
  end
 

  p=po.find_element(:css, "td:nth-child(2)") rescue false
  if p !=false
  @price=p.attribute("textContent").split(" ").join(" ")
  
else
  puts "price else===#{p}"
end
  
  o=po.find_element(:css, "td:nth-child(3)") rescue false
  if o!= false
  @offer=o.attribute("textContent").split(" ").join(" ")
   
else
  puts "offer else===#{o}" 
end
 

    if ["#topup-gsm", "#topup-cdma"].any? {|n| type.include? n} then 
     @caty = "Talktime"
    else
        if v=po.find_element(:css, "td:nth-child(4)") rescue false
        @validity=v.attribute("textContent").split(" ").join(" ")
        
       else
        puts "validity else===#{v}" 
    end 
  end
  if caty.blank?
    @name = "#{@price} #{@@pre} #{@region_name} #{@operator_name}"
    puts "here==#{@name}"
    @caty =@@pre2
    puts "there#{@caty}"
  else

    @name ="#{@price} #{caty} #{@region_name} #{@operator_name}"
    @@pre =caty
    puts "from not nil===#{@@pre}"
    if ["FreePaid Pack", "Minutes Pack", "Special Tariff Recharge","*Unlimited Pack", "Unlimited Pack"].any? {|n| caty.include? n} 
      then @caty = "Ratecutters" end  
    if ["2G Data Pack","2G Pack"].any? {|n| caty.include? n}  then @caty = "GPRS" end
    if ["3G Data Pack","3G Pack"].any? {|n| caty.include? n}  then @caty = "3G-Data" end
    if caty.include?("Combo Pack") then @caty ="Combo" end
    if caty.include?("ISD Pack") then @caty ="ISD" end
    if caty.include?("Roaming Pack") then @caty ="Roaming" end
    if caty.include?("SMS Pack") then @caty ="SMS" end
    @@pre2=@caty
  end
  

if (@price.to_i>9 && p != false)
   update_database
end

end
end
driver.close
headless.destroy
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