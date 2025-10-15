# api/app/models/user.rb

class User < ApplicationRecord
  # Provided by the 'bcrypt' gem via 'has_secure_password'.
  # This automatically manages the hashing and comparison of passwords
  # using the 'password_digest' column.
  has_secure_password

  # --- Validations ---
  validates :username, presence: true, uniqueness: true, length: { minimum: 3 }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }


  # --- JWT Authentication Methods ---

  # Uses the secure base key from the Rails application
  # This ensures the token signature is verifiable only by this application.
  # Note: The 'production' environment would typically use an ENV variable for this.
  SECRET_KEY = Rails.application.secret_key_base

  # Encodes the user ID and an expiration time into a JWT.
  #
  # @return [String] The signed JWT.
  def encode_token
    # Payload contains user ID and expiration time (24 hours from now)
    payload = { user_id: self.id, exp: 24.hours.from_now.to_i }
    JWT.encode(payload, SECRET_KEY)
  end

  # Decodes a JWT to retrieve the user ID.
  #
  # @param token [String] The JWT provided by the client.
  # @return [Hash, nil] The decoded payload, or nil if decoding fails.
  def self.decode_token(token)
    # The decode method returns an array: [payload, header]
    JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256').first
  rescue JWT::DecodeError
    # Returns nil if the token is invalid, expired, or the signature doesn't match
    nil
  end
end