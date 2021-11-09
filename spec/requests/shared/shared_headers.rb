RSpec.shared_context 'shared headers' do
  # headers for requests (required for authentication)
  let(:headers) do
    user = create(:user)
    login_params = {
      email: user.email,
      password: user.password
    }
    post user_session_url, params: login_params, as: :json

    {
      'uid' => response.headers['uid'],
      'client' => response.headers['client'],
      'access-token' => response.headers['access-token']
    }
  end
end
