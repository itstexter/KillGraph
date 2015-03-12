require 'lol'

class KillgraphController < ApplicationController
	CHAMPION_KILL = "CHAMPION_KILL"

	def index
	end

	def lookup
		@username = params[:username]

		# try to get username
		@is_valid_user = true

		# Go ahead and grab user match data

		summoner_id = @client.summoner.by_name(@username)[0].id
		matches = @client.match_history.get(summoner_id)['matches']
		kill_events = []
		matches.first(4).each do |match|
			kill_events += get_kill_events_from_match_id(match["matchId"], summoner_id)
		end
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
		summoner_name = params[:username]

		match_details = {match_victory: true, match_type: "Ranked 5x5", match_time: "38:55"}
		summoner_spells = [{name: 'Flash', description: 'Move a distance',},
		 {name: 'Smite', description: 'Damage a minion'}]
		gold_earned = 12648
		creep_score = {minions: 133, monsters: 32}
		team_1_players = ['ItsTexter', 'ucbStirlingfffffff', 'TweePop', 'Echennial', 'Lord Derek']
		team_2_players = ['cinnamondolce', 'elane4lyfe', 'edizzle', 'tayswif', 'Lord Elaine']
		items = [{name: 'item0', description: '<b>Boots of Swiftness</b> <br> +30 Movement Speed'},
		 {name: 'item1', description: '<b>Long Sword</b> <br> +10 Attack Damage'}, 
		 {name: 'item2', description: '<b>Amplifying Tomb</b> <br> +15 Ability Power'}, 
		 {name: 'item3', description: '<b>UUUUUOOOOOHHHHHH</b>'}, 
		 {name: 'item4', description: '<i>Potato</i>'}, 
		 {name: 'item5', description: '<b>HIIMDAISY</b>'}]

		trinket = {name: 'Scrying Orb', description: '<b>Scrying Orb</b> <br> Reveal an area for 15 seconds'}

		json_response = {
			matches_history: render_to_string(
				partial:"killgraph/match_history_row", 
				locals: { match_details: match_details,
						  summoner_name: summoner_name,
						  summoner_spells: summoner_spells,
						  kills: 5, 
						  deaths: 3, 
						  assists: 17,
						  level: 13,
						  creep_score: creep_score,
						  gold_earned: gold_earned,
						  items: items,
						  trinket: trinket,
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
			if (true)
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
