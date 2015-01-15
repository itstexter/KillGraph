class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_client

  def set_client
	@client = Lol::Client.new "bc9ba4d5-e50c-41f0-b2f5-d8ab0aeda1b7", {region: "na"}
  end
end
