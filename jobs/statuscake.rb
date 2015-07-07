require 'json'
require 'pp'

username = ENV['STATUSCAKE_USERNAME']
key = ENV['STATUSCAKE_API_KEY']
testids = ENV['STATUSCAKE_TEST_IDS'].split(',')

SCHEDULER.every '10m', :first_in => 0 do |job|
	items=[]
	is_down=0
	overall_status='ok'
	testids.each do |testid|
    response = Net::HTTP.get_response(URI('https://www.statuscake.com/API/Tests/Details/?TestID='+testid+'&Username='+username+'&API='+key))
    website = JSON.parse(response.body)
    items << { site: website['WebsiteName'], status: website['Status'], lasttest: website['LastTested'] }
    if website['Status']!='Up'
      overall_status='warning'
    end
  end

  send_event('statuscake', { items:items,overall_status: overall_status })

end
