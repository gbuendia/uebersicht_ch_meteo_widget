# Swiss meteorological data from selected weather stations.
# Data is obtained from Data from http://opendata.netcetera.com
# Inspired by disk-usage-bar.widget https://github.com/onishy/Ubersicht-DiskUsage-bar

# CONFIGURATION
# The three-letter code for your preferred station can be obtained at:
# http://www.meteoschweiz.admin.ch/home/mess-und-prognosesysteme/bodenstationen/automatisches-messnetz.html
station = "BER"
language = "en" # available: de (deutsch), fr (français), it (italiano), rm (rumatsch)

########################################################################################
# Changes below this line might break things

labels = {
	en: ["Temperature", "Sunshine", "Humidity", "Precipitation", "Wind speed", "Wind direction"],
	de: ["Temperatur", "Sonnenschein", "Feuchtigkeit", "Niederschlag", "Windgeschwindigkeit", "Windrichtung"],
	fr: ["Température", "Ensoleillement", "Humidité", "Précipitation", "Vitesse du vent", "Direction du vent"],
	it: ["Temperatura", "Soleggiamento", "Umidità", "Precipitazioni", "Velocità del vento", "Direzione del vento"],
	rm: ["Temperatura", "Sulegl", "Umiditad", "Precipitaziun", "Spertadat dal vent", "Direcziun dal vent"]
}

command: (callback) ->
  proxy = "http://127.0.0.1:41417/"
  server = "http://opendata.netcetera.com:80"
  path = "/smn/smn/" + station
  $.get proxy + server + path, (json) ->
    callback null, json

refreshFrequency: 1000 * 60 * 10 # New data is available every 10 minutes

style: """
	top: 100px
	left: 10px

	color: #fff
	font-family: Helvetica Neue
	background: rgba(#000, .5)
	padding: 10px 10px 5px
	border-radius: 5px

	#widget
		width: 300px
		clear: both
		position: relative

	#header
		width: 100%
		text-transform: uppercase
		font-size: 11px
		font-weight: bold
		padding-bottom: 20px

	#station
		float: left

	#timestamp
		float: right

	#body
		width: 100%
		display: flex
		flex-wrap: wrap
		flex-direction: row
		justify-content: space-between

	.data
		flex-basis: 30%
		float: left
		text-align: center
		margin-bottom: 10px

	.data-value
		width: 100%
		clear: both
		font-size: 20px
		font-weight: 100

	.data-label
		width: 100%
		font-size: 8px
		text-transform: uppercase

"""

render: -> """
	<div id="widget">
		<div id="header">
			<div id="station"></div>
			<div id="timestamp"></div>
		</div>
		<div id="body">
			<div class="data">
				<div class="data-value" id="value-temperature"></div>
				<div class="data-label" id="label-temperature"></div>
			</div>
			<div class="data">
				<div class="data-value" id="value-sunshine"></div>
				<div class="data-label" id="label-sunshine"></div>
			</div>
			<div class="data">
				<div class="data-value" id="value-humidity"></div>
				<div class="data-label" id="label-humidity"></div>
			</div>
			<div class="data">
				<div class="data-value" id="value-precipitation"></div>
				<div class="data-label" id="label-precipitation"></div>
			</div>
			<div class="data">
				<div class="data-value" id="value-windspeed"></div>
				<div class="data-label" id="label-windspeed"></div>
			</div>
			<div class="data">
				<div class="data-value" id="value-winddirection"></div>
				<div class="data-label" id="label-winddirection"></div>
			</div>
		</div>
	</div>
"""

update: (output, domEl) ->

	stationShort = output["station"]["name"]
	$(domEl).find("#station").text stationShort

	# Server sends the time in the form YYYY-MM-DDTHH:MM:SS.ZZZZZ
	# We just need HH and MM
	zuluTime = output["dateTime"].split("T")[1].split(":")
	hour = zuluTime[0]
	minute = zuluTime[1]
	# We need the offset between Zulu and local
	# which is the same as between UTC and local
	real_hour = `function(zulu_hour) {
		var today = new Date
		off_min = today.getTimezoneOffset() // I couldn't make this workk in Coffee
		off_hrs = off_min / -60
		return zulu_hour + off_hrs
	}`
	$(domEl).find("#timestamp").text real_hour(parseInt(hour,10)) + ":" + minute

	# Populate labels
	$(domEl).find("#label-temperature").text labels[language][0]
	$(domEl).find("#label-sunshine").text labels[language][1]
	$(domEl).find("#label-humidity").text labels[language][2]
	$(domEl).find("#label-precipitation").text labels[language][3]
	$(domEl).find("#label-windspeed").text labels[language][4]
	$(domEl).find("#label-winddirection").text labels[language][5]

	# Populate data

	temperature = Math.round parseInt(output["temperature"],10)
	$(domEl).find("#value-temperature").text temperature + " ºC"

	sunshine = parseInt(output["sunshine"],10)
	$(domEl).find("#value-sunshine").text sunshine + "'/10'"

	humidity = Math.round parseInt(output["humidity"],10)
	$(domEl).find("#value-humidity").text humidity + " %"

	precipitation = Math.round parseInt(output["precipitation"],10)
	$(domEl).find("#value-precipitation").text precipitation + " mm"

	windspeed = Math.round parseInt(output["windSpeed"],10)
	$(domEl).find("#value-windspeed").text windspeed + " km/h"

	winddirection = parseInt(output["windDirection"],10)
	compass = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW", "N"]
	sectors = Math.round winddirection / 22.5
	friendly_direction = compass[sectors]
	$(domEl).find("#value-winddirection").text friendly_direction
