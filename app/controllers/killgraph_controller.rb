require 'lol'

class KillgraphController < ApplicationController
	def index
		@whatever = "whatever"
	end

	def lookup
		username = params[:username]

		client = Lol::Client.new "", {region: "na"}

		id = client.summoner.by_name(username)[0].id
		@data = client.game.recent(id)

		# @data = client.game.get(game_id)

	end
end
