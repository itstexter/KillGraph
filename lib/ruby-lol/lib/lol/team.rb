require 'lol/model'

module Lol
  class Team < Lol::Model
    # @!attribute [r] create_date
    # @return [Time] Create Date
    attr_reader :create_date

    # @!attribute [r] full_id
    # @return [String] Full Team ID
    attr_reader :full_id

    # @!attribute [r] last_game_date
    # @return [Time] Last Game Date
    attr_reader :last_game_date

    # @!attribute [r] last_join_date
    # @return [Time] Last Join Date
    attr_reader :last_join_date

    # @!attribute [r] last_joined_ranked_team_queue_date
    # @return [Time] Last Joined Ranked Team Queue Date
    attr_reader :last_joined_ranked_team_queue_date

    # @!attribute [r] match_history
    # @return [Array] List of played matches
    attr_reader :match_history

    # @!attribute [r] modify_date
    # @return [Time] Modified Date
    attr_reader :modify_date

    # @!attribute [r] name
    # @return [String] Team name
    attr_reader :name

    # @!attribute [r] roster
    # @return [Roster] Roster
    attr_reader :roster

    # @!attribute [r] second_last_join_date
    # @return [Time] Second Last Join Date
    attr_reader :second_last_join_date

    # @!attribute [r] status
    # @return [String] Status
    attr_reader :status

    # @!attribute [r] tag
    # @return [String] Team Tag
    attr_reader :tag

    # @!attribute [r] team_stat_details
    # @return [Array] List of Team Statistics
    attr_reader :team_stat_details

    # @!attribute [r] third_last_join_date
    # @return [Time] Third Last Join Date
    attr_reader :third_last_join_date

    private

    attr_writer :name, :status, :tag, :full_id

    def create_date= value
      @create_date = value.is_a?(Numeric) && Time.at(value / 1000) || value
    end

    def last_game_date= value
      @last_game_date = value.is_a?(Numeric) && Time.at(value / 1000) || value
    end

    def last_join_date= value
      @last_join_date = value.is_a?(Numeric) && Time.at(value / 1000) || value
    end

    def last_joined_ranked_team_queue_date= value
      @last_joined_ranked_team_queue_date = value.is_a?(Numeric) && Time.at(value / 1000) || value
    end

    def second_last_join_date= value
      @second_last_join_date = value.is_a?(Numeric) && Time.at(value / 1000) || value
    end

    def third_last_join_date= value
      @third_last_join_date = value.is_a?(Numeric) && Time.at(value / 1000) || value
    end

    def modify_date= value
      @modify_date = value.is_a?(Numeric) && Time.at(value / 1000) || value
    end

    def match_history= collection
      @match_history = collection.map do |c|
        c.respond_to?(:[]) && MatchSummary.new(c) || c
      end
    end

    def roster= roster
      @roster = roster.is_a?(Hash) && Roster.new(roster) || roster
    end

    def team_stat_details= value
      collection = value.is_a?(Hash) && value['teamStatDetails'] || value
      @team_stat_details = collection.map do |c|
        c.respond_to?(:[]) && TeamStatistic.new(c) || c
      end
    end
  end
end
