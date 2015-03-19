require 'lol'

class KillgraphController < ApplicationController
	CHAMPION_KILL = "CHAMPION_KILL"

	def index
	end

	def lookup
		@username = params[:username].downcase.gsub(' ', '')

		user = User.where(summoner_name: @username).first

		@is_valid_user = false
		@kill_events_by_match = {}
		@matches_to_display = []

		if user.blank?
			begin
				summoner = @client.summoner.by_name(@username).first
			rescue Exception => e
				logger.error "no user"
				return
			end
			user = User.create(summoner_id: summoner.id, summoner_name: summoner.name.downcase.gsub(' ', ''), display_name: summoner.name)
		end

		summoner_id = user.summoner_id

		@is_valid_user = true

		# Go ahead and grab user match data
		matches = @client.match_history.get(summoner_id)['matches']
		@matches_to_display = matches.first(4)
		@matches_to_display.each do |match|
			matchId = match["matchId"]
			@kill_events_by_match[matchId] = get_kill_events_from_match_id(matchId, summoner_id)
		end
	end

	private

	def get_kill_events_from_match_id(match_id, summoner_id)
		match_data = @client.match.get(match_id, true) # Added true for some texter thing
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
