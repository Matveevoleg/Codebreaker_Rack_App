require 'spec_helper'

RSpec.describe Racker do
  subject { Rack::MockRequest.new(Racker) }

  %w(/ /start /get_hint /input).each do |item|
    specify "#{item} get responce 200" do
      expect(subject.get(item).status).to eq 200
    end
  end

  specify 'get responce 404' do
    expect(subject.get('/qwerty').status).to eq 404
  end

  specify 'check buttons' do
    expect(subject.get('/').body).to match(/<input type="submit" value="Start">/)
    expect(subject.get('/start').body).to match(/<input type="submit" value="Check">/)
  end

  specify 'links' do
    expect(subject.get('/start').body).to match(/<a href="\/get_hint">Get hint<\/a>/)
    expect(subject.get('/start').body).to match(/<a href="\/start">Restart<\/a>/)
    expect(subject.get('/start').body).to match(/<a href="\/">Exit<\/a>/)
  end

  specify 'attempts, hints count' do
    expect(subject.get('/input').body).to match(/Attempts: 5/)
    expect(subject.get('/input').body).to match(/Hints: 2/)
  end

  specify 'hints changed' do
    expect(subject.get('/get_hint').body).to match(/Hints: 1/)
  end
end