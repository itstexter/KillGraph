module Lol
  class Client

    # @!attribute [rw] region
    # @return [String] name of region
    attr_accessor :region

    # @!attribute [r] api_key
    # @return [String] the API key that has been used
    attr_reader :api_key

    # @!attribute [r] ttl
    # @return [Fixnum] the ttl on cached requests
    attr_reader :ttl

    # @return [ChampionRequest]
    def champion
      @champion_request ||= ChampionRequest.new(api_key, region, cache_store)
    end

    # @return [GameRequest]
    def game
      @game_request ||= GameRequest.new(api_key, region, cache_store)
    end

    # @return [MatchRequest]
    def match
      @match_request ||= MatchRequest.new(api_key, region, cache_store)
    end

    # @return [MatchHistoryRequest]
    def match_history
      @match_history_request ||= MatchHistoryRequest.new(api_key, region, cache_store)
    end

    # @return [StatsRequest]
    def stats
      @stats_request ||= StatsRequest.new(api_key, region, cache_store)
    end

    # @return [LeagueRequest]
    def league
      @league_request ||= LeagueRequest.new(api_key, region, cache_store)
    end

    # @return [TeamRequest]
    def team
      @team_request ||= TeamRequest.new(api_key, region, cache_store)
    end

    # @return [SummonerRequest]
    def summoner
      @summoner_request ||= SummonerRequest.new(api_key, region, cache_store)
    end

    # @return [StaticRequest]
    def static
      @static_request ||= StaticRequest.new(api_key, region, cache_store)
    end

    # @return [LolStatusRequest]
    def lol_status
      @lol_status ||= LolStatusRequest.new(region, cache_store)
    end

    # @return [CurrentGameRequest]
    def current_game
      @current_game ||= CurrentGameRequest.new(api_key, region, cache_store)
    end

    # @return [FeaturedGamesRequest]
    def featured_games
      @featured_games ||= FeaturedGamesRequest.new(api_key, region, cache_store)
    end

    # Initializes a Lol::Client
    # @param api_key [String]
    # @param options [Hash]
    # @option options [String] :region ("EUW") The region on which the requests will be made
    # @option options [String] :redis the redis url to use for caching
    # @option options [Fixnum] :ttl (900) the cache ttl
    # @return [Lol::Client]
    def initialize api_key, options = {}
      @api_key = api_key
      @region = options.delete(:region) || "euw"
      set_up_cache(options.delete(:redis), options.delete(:ttl))
    end

    def set_up_cache(redis_url, ttl)
      return @cached = false unless redis_url

      @ttl = ttl || 900
      @cached = true
      @redis = Redis.new :url => redis_url
    end

    # Returns an options hash with cache keys
    # @return [Hash]
    def cache_store
      {
        redis:  @redis,
        ttl:    @ttl,
        cached: @cached,
      }
    end

    # @return [Boolean] true if requests are cached
    def cached?
      @cached
    end

    # @return [Redis] the cache store (if available)
    def redis
      @redis
    end
  end
end
