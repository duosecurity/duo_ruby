require 'openssl'
require 'base64'
require_relative 'duo-rails/engine' if defined? Rails
require_relative 'duo-rails/railtie' if defined? Rails

##
# A Ruby implementation of the Duo WebSDK
#
module Duo
  DUO_PREFIX  = 'TX'.freeze
  APP_PREFIX  = 'APP'.freeze
  AUTH_PREFIX = 'AUTH'.freeze

  DUO_EXPIRE = 300
  APP_EXPIRE = 3600

  IKEY_LEN = 20
  SKEY_LEN = 40
  AKEY_LEN = 40

  ERR_USER = 'ERR|The username passed to sign_request() is invalid.'.freeze
  ERR_IKEY = 'ERR|The Duo integration key passed to sign_request() is invalid.'.freeze
  ERR_SKEY = 'ERR|The Duo secret key passed to sign_request() is invalid.'.freeze
  ERR_AKEY = "ERR|The application secret key passed to sign_request() must be at least #{Duo::AKEY_LEN} characters.".freeze

  # Sign a Duo 2FA request
  # @param ikey [String] The Duo IKEY
  # @param skey [String] The Duo SKEY
  # @param akey [String] The Duo AKEY
  # @param username [String] Username to authenticate as
  def sign_request(ikey, skey, akey, username)
    return Duo::ERR_USER if !username || username.empty?
    return Duo::ERR_USER if username.include? '|'
    return Duo::ERR_IKEY if !ikey || ikey.to_s.length != Duo::IKEY_LEN
    return Duo::ERR_SKEY if !skey || skey.to_s.length != Duo::SKEY_LEN
    return Duo::ERR_AKEY if !akey || akey.to_s.length < Duo::AKEY_LEN

    vals = [username, ikey]

    duo_sig = sign_vals(skey, vals, Duo::DUO_PREFIX, Duo::DUO_EXPIRE)
    app_sig = sign_vals(akey, vals, Duo::APP_PREFIX, Duo::APP_EXPIRE)

    return [duo_sig, app_sig].join(':')
  end

  # Verify a Duo 2FA request
  # @param ikey [String] The Duo IKEY
  # @param skey [String] The Duo SKEY
  # @param akey [String] The Duo AKEY
  # @param sig_response [String] Response from Duo service
  def verify_response(ikey, skey, akey, sig_response)
    begin
      auth_sig, app_sig = sig_response.to_s.split(':')
      auth_user = parse_vals(skey, auth_sig, Duo::AUTH_PREFIX, ikey)
      app_user = parse_vals(akey, app_sig, Duo::APP_PREFIX, ikey)
    rescue
      return nil
    end

    return nil if auth_user != app_user

    return auth_user
  end

  private

  def hmac_sha1(key, data)
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), key, data.to_s)
  end

  def sign_vals(key, vals, prefix, expire)
    exp = Time.now.to_i + expire

    val_list = vals + [exp]
    val = val_list.join('|')

    b64 = Base64.encode64(val).delete("\n")
    cookie = prefix + '|' + b64

    sig = hmac_sha1(key, cookie)
    return [cookie, sig].join('|')
  end

  def parse_vals(key, val, prefix, ikey)
    ts = Time.now.to_i

    parts = val.to_s.split('|')
    return nil if parts.length != 3
    u_prefix, u_b64, u_sig = parts

    sig = hmac_sha1(key, [u_prefix, u_b64].join('|'))

    return nil if hmac_sha1(key, sig) != hmac_sha1(key, u_sig)

    return nil if u_prefix != prefix

    cookie_parts = Base64.decode64(u_b64).to_s.split('|')
    return nil if cookie_parts.length != 3
    user, u_ikey, exp = cookie_parts

    return nil if u_ikey != ikey

    return nil if ts >= exp.to_i

    return user
  end

  extend self
end
