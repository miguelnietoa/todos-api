# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Session', type: :request do
  let(:user) { create(:user) }

  let(:login_params) do
    {
      email: user.email,
      password: user.password
    }
  end

  describe 'POST /auth/sign_in' do
    context 'when login params is valid' do
      before do
        post user_session_url, params: login_params, as: :json
      end
      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end
      it 'returns access-token in authentication header' do
        expect(response.headers['access-token']).to be_present
      end
      it 'returns client in authentication header' do
        expect(response.headers['client']).to be_present
      end
      it 'returns expiry in authentication header' do
        expect(response.headers['expiry']).to be_present
      end
      it 'returns uid in authentication header' do
        expect(response.headers['uid']).to be_present
      end
    end
    context 'when login params is invalid' do
      before { post user_session_url }
      it 'returns unathorized status 401' do
        expect(response).to have_http_status(401)
      end
    end
  end
  describe 'DELETE /auth/sign_out' do
    before do
      # Login user created in the `before` block in outer `describe` block
      post user_session_url, params: login_params, as: :json
    end

    let(:headers) do
      {
        'uid' => response.headers['uid'],
        'client' => response.headers['client'],
        'access-token' => response.headers['access-token']
      }
    end

    it 'returns status 200' do
      delete destroy_user_session_url, headers: headers
      expect(response).to have_http_status(200)
    end
  end
end
