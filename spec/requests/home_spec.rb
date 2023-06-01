# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Homes', type: :request do
  let!(:user) { FactoryBot.create(:user) }

  describe 'GET /' do
    it 'show home page successfully' do
      get '/'
      expect(response.status).to eq(200)
    end

    it 'show home page successfully after login' do
      sign_in_as(user)
      get '/'
      expect(response.status).to eq(200)
    end
  end
end
