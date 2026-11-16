
require "digest"

module Sessions
  class Authenticate
    def initialize(token:)
      @token = token
    end

    def call
      return nil if @token.blank?

      digest = Digest::SHA256.hexdigest(@token)

      session = Session.find_by(token_digest: digest)

      return nil unless session
      return nil unless session.expires_at > Time.current

      session.user
    end
  end
end
