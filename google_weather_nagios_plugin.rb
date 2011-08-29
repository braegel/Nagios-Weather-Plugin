#! ruby 
# ^^^^^ maybe you have to change this
begin 
  require 'net/http'
  require 'xmlsimple'

  nagios_value = 3
  current=Hash.new


  # get the XML data as a string
  xml_data = Net::HTTP.get_response(URI.parse('http://www.google.com/ig/api?weather=Dueren')).body
  # Adapt this to your needs ->    ->    ->     ->     ->     ->                    ^^^^^^
  # Inofficial API documentation http://www.hackthenet.de/weblog/225/google-wetter-api

  #That was the most tricky part:
  xml_data = xml_data.encode("utf-8", "iso-8859-1")
  #p xml_data

  data = XmlSimple.xml_in(xml_data)


  data['weather'][0]['current_conditions'][0].each do |raw|
    current[raw[0]]=raw[1][0]['data']
  end


  # rules for nagios status (0 - all ok 1 - warning 2 - critical 3 - unknown)
  # maybe you would like to refere to this: http://www.blindmotion.com/2009/03/google-weather-api-images/

  p current

  if current['icon']=~/\/sunny.gif$/
    nagios_value = 1
  end
  if current['icon']=~/\/chance_of_rain.gif$/
    nagios_value = 2
  end
  if current['icon']=~/\/mostly_sunny.gif$/
    nagios_value = 1
  end
  if current['icon']=~/\/partly_cloudy.gif$/
    nagios_value = 1
  end
  if current['icon']=~/\/mostly_cloudy.gif$/
    nagios_value = 1
  end
  if current['icon']=~/\/chance_of_storm.gif$/
    nagios_value = 3
  end
  if current['icon']=~/\/chance_of_snow.gif$/
    nagios_value = 2
  end
  if current['icon']=~/\/cloudy.gif$/
    nagios_value = 1
  end
  if current['icon']=~/\/mist.gif$/
    nagios_value = 1
  end
  if current['icon']=~/\/storm.gif$/
    nagios_value = 3
  end
  if current['icon']=~/\/thunderstorm.gif$/
    nagios_value = 3
  end
  if current['icon']=~/\/chance_of_tstorm.gif$/
    nagios_value = 2
  end
  if current['icon']=~/\/sleet.gif$/
    nagios_value = 3
  end
  if current['icon']=~/\/snow.gif$/
    nagios_value = 3
  end
  if current['icon']=~/\/icy.gif$/
    nagios_value = 3
  end
  if current['icon']=~/\/dust.gif$/
    nagios_value = 2
  end
  if current['icon']=~/\/fog.gif$/
    nagios_value = 1
  end
  if current['icon']=~/\/smoke.gif$/
    nagios_value = 3
  end
  if current['icon']=~/\/haze.gif$/
    nagios_value = 1
  end
  if current['icon']=~/\/flurries.gif$/
    nagios_value = 3
  end
  
  if current['temp_c'].to_f<=1
      nagios_value = 2
  end
    
  exit nagios_value
  
rescue NoMemoryError => e
  puts "#{ e } (#{ e.class })!"
  exit 3
rescue SignalException => e
  puts "#{ e } (#{ e.class })!"
  exit 3
rescue ScriptError => e
  puts "#{ e } (#{ e.class })!"
  exit 3
rescue SignalException => e
  puts "#{ e } (#{ e.class })!"
  exit 3
rescue StandardError => e
  puts "#{ e } (#{ e.class })!"
  exit 3
rescue SystemStackError => e
  puts "#{ e } (#{ e.class })!"
  exit 3
end