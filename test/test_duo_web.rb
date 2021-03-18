require 'test/unit'
require 'duo_web'

IKEY = 'DIXXXXXXXXXXXXXXXXXX'.freeze
WRONG_IKEY = 'DIXXXXXXXXXXXXXXXXXY'.freeze
SKEY = 'deadbeefdeadbeefdeadbeefdeadbeefdeadbeef'.freeze
AKEY = 'useacustomerprovidedapplicationsecretkey'.freeze

USER = 'testuser'.freeze

INVALID_RESPONSE = 'AUTH|INVALID|SIG'.freeze
EXPIRED_RESPONSE = 'AUTH|dGVzdHVzZXJ8RElYWFhYWFhYWFhYWFhYWFhYWFh8MTMwMDE1Nzg3NA==|cb8f4d60ec7c261394cd5ee5a17e46ca7440d702'.freeze
FUTURE_RESPONSE = 'AUTH|dGVzdHVzZXJ8RElYWFhYWFhYWFhYWFhYWFhYWFh8MjI0NzE0MDkyMQ==|d5fa72f8ba5f3d37d70dad615ff4901a77d46989'.freeze
WRONG_PARAMS_RESPONSE = 'AUTH|dGVzdHVzZXJ8RElYWFhYWFhYWFhYWFhYWFhYWFh8MTYxNTcyNzI0M3xpbnZhbGlkZXh0cmFkYXRh|6cdbec0fbfa0d3f335c76b0786a4a18eac6cdca7'.freeze
WRONG_PARAMS_APP = 'APP|dGVzdHVzZXJ8RElYWFhYWFhYWFhYWFhYWFhYWFh8MTYxNTcyNzI0M3xpbnZhbGlkZXh0cmFkYXRh|7c2065ea122d028b03ef0295a4b4c5521823b9b5'.freeze

##
# Test Duo Ruby WebSDK implementation
#
class TestDuo < Test::Unit::TestCase
  def test_sign_request
    request_sig = Duo.sign_request(IKEY, SKEY, AKEY, USER)
    assert_not_equal(request_sig, nil)

    request_sig = Duo.sign_request(IKEY, SKEY, AKEY, '')
    assert_equal(request_sig, Duo::ERR_USER)

    request_sig = Duo.sign_request(IKEY, SKEY, AKEY, 'in|valid')
    assert_equal(request_sig, Duo::ERR_USER)

    request_sig = Duo.sign_request('invalid', SKEY, AKEY, USER)
    assert_equal(request_sig, Duo::ERR_IKEY)

    request_sig = Duo.sign_request(IKEY, 'invalid', AKEY, USER)
    assert_equal(request_sig, Duo::ERR_SKEY)

    request_sig = Duo.sign_request(IKEY, SKEY, 'invalid', USER)
    assert_equal(request_sig, Duo::ERR_AKEY)
  end

  def test_verify_response
    request_sig = Duo.sign_request(IKEY, SKEY, AKEY, USER)
    _duo_sig, valid_app_sig = request_sig.to_s.split(':')

    request_sig = Duo.sign_request(IKEY, SKEY, 'invalid' * 6, USER)
    _duo_sig, invalid_app_sig = request_sig.to_s.split(':')

    invalid_user = Duo.verify_response(IKEY, SKEY, AKEY, INVALID_RESPONSE + ':' + valid_app_sig)
    assert_equal(invalid_user, nil)

    expired_user = Duo.verify_response(IKEY, SKEY, AKEY, EXPIRED_RESPONSE + ':' + valid_app_sig)
    assert_equal(expired_user, nil)

    future_user = Duo.verify_response(IKEY, SKEY, AKEY, FUTURE_RESPONSE + ':' + invalid_app_sig)
    assert_equal(future_user, nil)

    future_user = Duo.verify_response(IKEY, SKEY, AKEY, FUTURE_RESPONSE + ':' + valid_app_sig)
    assert_equal(future_user, USER)

    future_user = Duo.verify_response(IKEY, SKEY, AKEY, FUTURE_RESPONSE + ':' + WRONG_PARAMS_APP)
    assert_equal(future_user, nil)

    future_user = Duo.verify_response(IKEY, SKEY, AKEY, WRONG_PARAMS_RESPONSE + ':' + valid_app_sig)
    assert_equal(future_user, nil)

    future_user = Duo.verify_response(WRONG_IKEY, SKEY, AKEY, FUTURE_RESPONSE + ':' + valid_app_sig)
    assert_equal(future_user, nil)
  end
end
