require 'lol'

class KillgraphController < ApplicationController
	CHAMPION_KILL = "CHAMPION_KILL"

	def index
	end

	def lookup
		username = params[:username]

		client = Lol::Client.new "bc9ba4d5-e50c-41f0-b2f5-d8ab0aeda1b7", {region: "na"}

		summoner_id = client.summoner.by_name(username)[0].id
		matches = client.match_history.get(summoner_id)['matches']
		
		match = matches[0]
		match_data = client.match.get(match["matchId"], true)

		get_kill_events_from_match(match_data, summoner_id)
	end

	def get_kill_events_from_match(match_data, summoner_id)
		champion_kills = []
		frames = match_data["timeline"]["frames"]
		frames.each do |frame|
			if frame["events"].present?
				frame["events"].each do |event|
					if event["eventType"] == CHAMPION_KILL
						champion_kills << event
					end
				end
			end	
		end

		@data = match_data
		# @data = champion_kills
	end
end
