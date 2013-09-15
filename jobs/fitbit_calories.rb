require "fitgem"
require "yaml"

current_calories = 0
last_calories = 0

# jeden Tag um 22:00 werden die Daten aktualisiert
SCHEDULER.cron '0 22 * * *' do
  config = Fitgem::Client.symbolize_keys(YAML.load(File.open("lib/fitbit/fitgem.yml")))
  fitbit_client = Fitgem::Client.new(config[:oauth])
  access_token = fitbit_client.reconnect(config[:oauth][:token], config[:oauth][:secret])
  today_activity = fitbit_client.activities_on_date(Date.today)
  yesterday_activity = fitbit_client.activities_on_date(Date.today.prev_day)
  current_calories = today_activity["summary"]["activityCalories"]
  last_calories = yesterday_activity["summary"]["activityCalories"]
  send_event('fitbit_calories', { current: current_calories, last: last_calories })
end
