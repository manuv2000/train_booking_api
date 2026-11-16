
require "securerandom"
require "digest"

module Sessions
  class Issue
    def initialize(user:)
      @user = user
    end

    def call
      token = SecureRandom.hex(32)
      digest = Digest::SHA256.hexdigest(token)

      session = @user.sessions.create!(
        token_digest: digest,
        expires_at: 7.days.from_now
      )

      { token: token, session: session }
    end
  end
end
