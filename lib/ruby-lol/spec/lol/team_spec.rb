require "spec_helper"
require "lol"

include Lol

describe Team do
  it_behaves_like 'Lol model' do
    let(:valid_attributes) { {  } }
  end

  %w(full_id name status tag).each do |attribute|
    describe "#{attribute} attribute" do
      it_behaves_like 'plain attribute' do
        let(:attribute) { attribute }
        let(:attribute_value) { 'asd' }
      end
    end
  end

  %w(create_date last_game_date last_join_date second_last_join_date third_last_join_date last_joined_ranked_team_queue_date modify_date).each do |attribute|
    describe "#{attribute} attribute" do
      it_behaves_like 'time attribute' do
        let(:attribute) { attribute }
      end
    end
  end

  describe 'match_history attribute' do
    it_behaves_like 'collection attribute' do
      let(:attribute) { 'match_history' }
      let(:attribute_class) { MatchSummary }
    end
  end

  describe 'team_stat_details attribute' do
    it_behaves_like 'collection attribute' do
      let(:attribute) { 'team_stat_details' }
      let(:attribute_class) { TeamStatistic }
      let(:attribute_value) { { 'teamStatDetails' => [{}, {}] } }
    end
  end

  describe 'roster attribute' do
    it_behaves_like 'plain attribute' do
      let(:attribute) { 'create_date' }
      let(:attribute_value) { 'asd' }
    end

    it 'parses the value if it is an Hash' do
      model = Team.new roster: {}
      expect(model.roster).to be_a Roster
    end
  end
end
