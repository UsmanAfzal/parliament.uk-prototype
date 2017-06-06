require 'rails_helper'

RSpec.describe 'resource/show', vcr: true do
  before(:each) do
    render
  end

  it 'displays the correct text' do
    expect(rendered).to match(/Hllo/)
  end
end
