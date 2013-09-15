require 'Nike'
require 'yaml'

config = YAML.load(File.open("lib/nikeplus/nikeplus.yml"))

SCHEDULER.in '2d' do
  nike_client = Nike::Client.new(config['name'], config['auth'])
  all_activities = nike_client.detailed_activities
  last_activity = all_activities.last
  last_distance = sprintf('%.2f', last_activity["distance"])
  send_event('nikeplus',   { value: last_distance })
end
