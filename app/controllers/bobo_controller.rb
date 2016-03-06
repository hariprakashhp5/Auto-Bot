class BoboController < ApplicationController

def index
end


def testron
	headless=Headless.new
	headless.start	
	@driver = Selenium::WebDriver.for :firefox
puts "browser open"
@driver.navigate.to "https://web.whatsapp.com/" 
sleep 10  
@driver.save_screenshot('/home/prakash/ss.png')
puts "reached webpage"
wait = Selenium::WebDriver::Wait.new(:timeout => 1500000000000000000000000000000)
wait.until { @driver.find_element(:id => "side").displayed? }
puts "waiting for side"
while 1<2 do
	puts "waiting for unread"
	sleep 2
wait.until { @driver.find_element(:class => "unread").displayed? }
puts "found unread"
unread_mess=@driver.find_element(:class, "unread").click

mess=@driver.find_elements(:css, ".message-text span").last

@content=mess.attribute("textContent")
puts @content
@inp=@driver.find_element(:css, "#main > footer > div > div.input-container > div > div.input")
if @content.include?("#about")
	puts "endered ifcond"
	about
elsif @content.include?("#info")
	mobile_number
elsif @content.include?("#pin")
	pincode
elsif @content.include?("#rc")
	recharge
elsif @content.include?("#std")
	std
elsif @content.include?("#isd")
	isd
elsif @content.include?("#love")
	love
end
@inp.send_key :return
end
@driver.close
headless.destroy
redirect_to '/'
end


def container
	@arrs.each do |arr|
    content = arr
    puts content
	@inp.send_key content
	@driver.action.key_down(:shift).send_keys("\n").key_up(:shift).perform
	end
end


def help
end



def love
	names=@content.split(/-/)
	fname=names[1]
	sname=names.last
	base="https://love-calculator.p.mashape.com/getPercentage?fname="+fname+"&sname="+sname
	page=HTTParty.get(base,
       :headers=>{"X-Mashape-Key"=>"jHICWb5yTymsh1qK3OiwusiJpnbOp123lDPjsn69Mo2hMRhobo","Accept"=>"application/json"})
	puts base
	puts page.code
	puts page["percentage"]
	if page.code== 200
		@arrs=["Love: #{page["percentage"]}%","#{page["result"]}","www.foryu.in"]
	else
		@arrs=["Sorry!!, Please try again"]
	end
		container
		return
end


def about
	name= "Foryu"
	site="www.foryu.in"
    mail="support@foryu.in"
    location= "Chennai, TamilNadu"
    abtus="Foryu is an ecommerce plateform which brings every information one step closer to the consumer."
    @arrs=["Name: #{name}","Web: #{site}","Mail: #{mail}","Location: #{location}","About Us: #{abtus}"]
    container
	return
end

def mobile_number

number=@content.scan(/\d+/).first
puts number
if (number != nil && number.length == 10)
	puts "searching"
	agent=Mechanize.new
	url="http://bmobile.in/"+number
	puts url
	page=agent.get(url)

	page.search('table').each do |i|
		@num=i.search('tr[2] td').text.strip
		@circ=i.search('tr[3] td').text.strip
		@op=i.search('tr[4] td').text.strip
		@sig=i.search('tr[5] td').text.strip

	end
			@arrs = ["Number: #{@num}","Circle: #{@circ}","Operator: #{@op}","Signel: #{@sig}","www.foryu.in"]
					
else
	@arrs=["Please Enter a Valid 10 digit Mobile Number"]
end
container
return
end

def pincode
	area_name=@content.split(/ /).last
	agent=Mechanize.new
	url="http://www.getpincode.info/"+area_name
	puts url
	page=agent.get(url)
	puts page.code
	if page.code == "200"
	code=page.search('#h1').text.strip
	@arrs=[area_name.capitalize+":",code,"www.foryu.in"]
else
	@arrs=["Sorry!!","Please Try Again","www.foryu.in"]
end
	container
	return
end

def std
	std_content=@content.split(/ /).last
	number=std_content.scan(/\d+/).first
	agent=Mechanize.new
	if number !=nil
	url="http://1min.in/telecom/stdcode/"+number
	puts url
	page=agent.get(url)
	puts page.code
	if page.code == "200"
		pacakage=page.search('table.table.table-bordered')
		pacakage.each do |pack|
    		@std_state=pack.search('tr[1] td[2]').text.strip
    		@std_loc=pack.search('tr[3] td[2]').text.strip
    		@std_code=pack.search('tr[4] td[2]').text.strip.split(/ /).last
    	end
    	@arrs=["State: #{@std_state}", "City: #{@std_loc}","STD Code: #{@std_code}","www.foryu.in"]
    else
    	@arrs=["Sorry!!","Please Try Again","www.foryu.in"]
    end
else
	url="http://www.tracephonenumber.in/std-codes/"+std_content
	puts url
	page=agent.get(url)
	puts page.code
	if page.code == "200"
		pacakage=page.search('h1').text.strip.split(/ /)
		@std_code=pacakage.last
		@std_loc=pacakage.first.split("'")[1]
		blabla=page.search('center h4').text.strip.split(/ /)
		@std_state=blabla[6]+" "+blabla[7]

	@arrs=["State: #{@std_state}", "City: #{@std_loc}","STD Code: #{@std_code}","www.foryu.in"]
else
	@arrs=["Sorry!!","Please Try Again","www.foryu.in"]
end
end
	container
	return
end

def isd
	isd_name=@content.split(/ /).last
	agent=Mechanize.new
	url="http://1min.in/telecom/isd/country/"+isd_name.capitalize
	puts url
	page=agent.get(url)
    puts page.code
    if page.code == "200"
    	pacakage=page.search('table.table.table-bordered')
    	pacakage.each do |pack|
    		@isd_country=pack.search('tr[1] td[2]').text.strip
    		@isd_code=pack.search('tr[2] td[2]').text.strip.split(/ /).last
    	end
    	@arrs=["Country: #{@isd_country}", "Code: #{@isd_code}","www.foryu.in"]
    else
    	@arrs=["Sorry!!","Please Try Again","www.foryu.in"]
    end
    container
    return
end


def recharge
	params=@content.split(/ /)
	puts params
	r_number=params[1]
	puts r_number
	r_amount=params.last
	puts r_amount
	payment=HTTParty.post('https://www.instamojo.com/api/1.1/payment-requests/', 
    :query=>{:api_key=>"c4f70085479c2e2ed38dbcd7377ef0df", :auth_token=>"8c57b6ca73a1c7ca26124889728fc39f"},
    :body=>{"purpose"=>"recharge", "amount"=>r_amount,
             "phone"=>r_number, "send_email"=>false, "send_sms"=>false,"allow_repeated_payments"=>false})
	result=JSON.parse(payment.body)
	puts result
	@arrs=["Please complete your payment.",result["payment_request"]["longurl"]]
	container
	return
end
end
