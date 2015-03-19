require File.expand_path("../../test_helper", __FILE__)

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'hi' do
  	user = User.create(summoner_name: 'tweepop', display_name: 'TweePop')
  	User.where(summoner_name: 'twe ep o p').first
  	assert true
  end
end
