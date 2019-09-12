Gem::Specification.new do |s|
  s.name        = 'duo_web'
  s.version     = '1.0.1'
  s.summary     = 'Duo Web Ruby'
  s.description = 'A Ruby implementation of the Duo Web SDK.'
  s.email       = 'support@duo.com'
  s.homepage    = 'https://github.com/duosecurity/duo_ruby'
  s.license     = 'BSD-3-Clause'
  s.authors     = ['Duo Security']
  s.files       = [
    'lib/duo_web.rb',
    'js/Duo-Web-v2.js',
    'js/Duo-Web-v2.min.js'
  ]
  s.add_development_dependency 'rake', '~> 0'
  s.add_development_dependency 'rubocop', '~> 0.49.0'
  s.add_development_dependency 'test-unit'
end
