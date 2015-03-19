require "spec_helper"
require "lol"

include Lol

describe Mastery do
  it_behaves_like 'Lol model' do
    let(:valid_attributes) { { id: 1 } }
  end

  %w(id rank).each do |attribute|
    it_behaves_like "plain attribute" do
      let(:attribute) { attribute }
      let(:attribute_value) { "asd" }
    end
  end
end
