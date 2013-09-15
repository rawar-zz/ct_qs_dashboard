require "fitgem"
require "yaml"

current_steps = 0
last_steps = 0

# jeden Tag um 22:00 werden die Daten aktualisiert
SCHEDULER.cron '0 22 * * *' do
  config = Fitgem::Client.symbolize_keys(YAML.load(File.open("lib/fitbit/fitgem.yml")))
  fitbit_client = Fitgem::Client.new(config[:oauth])
  access_token = fitbit_client.reconnect(config[:oauth][:token], config[:oauth][:secret])
  today_activity = fitbit_client.activities_on_date(Date.today)
  yesterday_activity = fitbit_client.activities_on_date(Date.today.prev_day)

  current_steps = today_activity["summary"]["steps"]
  last_steps = yesterday_activity["summary"]["steps"]

  send_event('fitbit_steps', { current: current_steps, last: last_steps })
end
