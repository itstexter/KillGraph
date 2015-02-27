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

		# summoner_id = @client.summoner.by_name(username)[0].id
		# matches = @client.match_history.get(summoner_id)['matches']

		kill_events = []
		# logger.debug "matches size is #{matches.length}"
		# matches.first(4).each do |match|
			# kill_events += get_kill_events_from_match_id(match["matchId"], summoner_id)
		# end

		# puts kill_events

		json_response = {
			champion_kills: kill_events
		}
		render json: json_response
	end

	def get_match_history
		username = params[:username]

		team_1_players = ['ItsTexter', 'ucbStirling', 'TweePop', 'Echennial', 'Lord Derek']
		team_2_players = ['cinnamondolce', 'elane4lyfe', 'edizzle', 'tayswif', 'Lord Elaine']
		items = ['item0', 'item1', 'item2', 'item3', 'item4', 'item5']

		json_response = {
			matches_history: render_to_string(partial:"killgraph/match_history_row", 
											  locals: { summoner_name: 'elainedabest',
											  			kills: 5, 
											  			deaths: 3, 
											  			assists: 17,
											  			level: 13, 
											  			items: items,
											  			team_1_players: team_1_players,
											  			team_2_players: team_2_players })
		}

		render json: json_response
	end

	private

	def get_kill_events_from_match_id(match_id, summoner_id)
		logger.debug "getting kills for champion_kills_#{match_id}"

		champion_kills = Rails.cache.fetch("champion_kills_#{match_id}")
		if champion_kills.blank?
			if (false)
				logger.debug "Hit something easy, get rid of it doofus."
				return []
			end

			match_data = @client.match.get(match_id, true)
			logger.debug "Missing cache, making new request for champion_kills_#{match_id}"
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

			Rails.cache.write("champion_kills_#{match_id}", champion_kills)
		else 
			logger.debug "Hit cache for champion_kills_#{match_id}"
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
