require 'mechanize'
require 'csv'

config = YAML.load(File.open("lib/nikeplus/weightbot.yml"))

a = Mechanize.new { |agent|
 agent.user_agent_alias = 'Mac Safari'
}
a.get('https://weightbot.com/account/login') do |login_page|
  my_page = login_page.form_with(:action => '/account/login') do |form|
    form.email = config['name']
    form.password = condig['auth']
  end.submit
  download_form = a.page.form_with(:action => '/export')
  download_button = my_page.form.button_with(:value => 'Download CSV')
  download_csv = a.submit(download_form, download_button)
  download_csv.save_as '/tmp/weights.csv'
end

points = []
weights = {}
day = 1
CSV.foreach("/tmp/weights.csv") do |row|
	date, kilograms, pounds = row
	next if date == "date"
	weights[date] = kilograms.lstrip
	points << {x: day, y: kilograms.lstrip.to_f}
	day += 1
end
last_x = points.last[:x]

SCHEDULER.every '2d' do
  send_event('weightbot', points: points)
end
