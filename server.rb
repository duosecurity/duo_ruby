require 'thin'
require 'duo_web'

puts(Rack::File.new('.'))
# Endpoint / view handler for responding to 2FA auth request and response.
class DuoLoginAdapter
  def initialize
    @host = ''
    @ikey = ''
    @skey = ''
    @akey = ''
    @username = ''
  end

  def call(env)
    request = Rack::Request.new(env)
    if request.get?
      sig_request = Duo.sign_request(@ikey, @skey, @akey, @username)
      body = ["
            <!DOCTYPE html>
            <html lang='en'>
              <head>
                <meta charset='UTF-8'>
                <title>Duo Authentication</title>
                <meta name='viewport' content='width=device-width, initial-scale=1'>
                <meta http-equiv='X-UA-Compatible' content='IE=edge'>
                <link rel='stylesheet' type='text/css' href='css/Duo-Frame.css'>
              </head>
              <body>
                <h1>Duo Authentication</h1>
                <form method='POST' id='duo_form'>
                </form>
                <iframe id='duo_iframe'
                        title='Two-Factor Authentication'
                        frameborder='0'
                        data-host='#{@host}'
                        data-sig-request='#{sig_request}'>
                </iframe>
                <script src='js/Duo-Web-v2.js'></script>
              </body>
            </html>
          "]
    elsif request.post?
      sig_response = request.params['sig_response']
      duo_user = Duo.verify_response(@ikey,
                                     @skey,
                                     @akey,
                                     sig_response)
      body = ["Auth Success! #{duo_user} is authenticated."]
    end

    [ 200, { 'Content-Type' => 'text/html' }, body ]
  end
end

app = Rack::URLMap.new('/' => DuoLoginAdapter.new,
                       '/js' => Rack::File.new('./js'),
                       '/css' => Rack::File.new('./css'))
Thin::Server.start('0.0.0.0', 3000, app)
