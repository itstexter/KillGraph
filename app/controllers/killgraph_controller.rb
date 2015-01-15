require 'lol'

class KillgraphController < ApplicationController
	CHAMPION_KILL = "CHAMPION_KILL"

	def index
	end

	def lookup
		@username = params[:username]
	end

	def get_coordinates
		username = params[:username]

		# Rails.cache.write("key", "avalue");
		# logger.debug "Rails cache value #{Rails.cache.fetch("key")}"
		
		summoner_id = @client.summoner.by_name(username)[0].id
		matches = @client.match_history.get(summoner_id)['matches']

		kill_events = []
		matches.first(1).each do |match|
			kill_events += get_kill_events_from_match_id(match["matchId"], summoner_id)
		end

		puts kill_events

		json_response = {
			champion_kills: kill_events
		}
		render json: json_response
	end

	private

	def get_kill_events_from_match_id(match_id, summoner_id)
		match_data = @client.match.get(match_id, true)

		participant_id = get_participant_id_from_match_data(match_data, summoner_id)

		champion_kills = []
		frames = match_data["timeline"]["frames"]
		frames.each do |frame|
			if frame["events"].present?
				frame["events"].each do |event|
					if event["eventType"] == CHAMPION_KILL && event["killerId"] == participant_id
						champion_kills << event
					end
				end
			end	
		end

		return champion_kills
	end

	def get_participant_id_from_match_data(match_data, summoner_id)
		match_data["participantIdentities"].each do |participant|
			if participant["player"]["summonerId"] == summoner_id
				return participant["participantId"]
			end
		end
	end
end
