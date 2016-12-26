require 'spec_helper'

RSpec.describe Racker do
  subject { Rack::MockRequest.new(Racker) }

  %w(/ /start /get_hint /input).each do |item|
    specify "#{item} get responce 200" do
      expect(subject.get(item).status).to eq 200
    end
  end
end