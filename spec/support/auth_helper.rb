# frozen_string_literal: true

module AuthHelper
  def sign_in_as(user)
    post user_session_path, params: {
      user: {
        email: user.email, password: user.password
      }
    }

    follow_redirect!
  end
end
