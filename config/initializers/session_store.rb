# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_delegator_session',
  :secret      => '63c6bcc10f4da048fcb883f79abb8303f99866a33171e0bfaa65bfaa8aa8c282569c96a721870c0fb1dae6e07cb6f2c7986006ff25036cc274588673e0bd763b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
