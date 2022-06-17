# Deprecation Notice

Duo Security will deprecate and archive this repository on July 18, 2022. The repository will remain public and visible after that date, and integrations built using this repository’s code will continue to work. You can also continue to fork, clone, or pull from this repository after it is deprecated.

However, Duo will not provide any further releases or enhancements after the deprecation date.

Duo recommends migrating your application to the Duo Universal Prompt. Refer to [our documentation](https://duo.com/docs/universal-prompt-update-guide) for more information on how to update.

For frequently asked questions about the impact of this deprecation, please see the [Repository Deprecation FAQ](https://duosecurity.github.io/faq.html)

----

# Overview

[![Build Status](https://github.com/duosecurity/duo_ruby/workflows/Ruby%20CI/badge.svg)](https://github.com/duosecurity/duo_ruby/actions)
[![Issues](https://img.shields.io/github/issues/duosecurity/duo_ruby)](https://github.com/duosecurity/duo_ruby/issues)
[![Forks](https://img.shields.io/github/forks/duosecurity/duo_ruby)](https://github.com/duosecurity/duo_ruby/network/members)
[![Stars](https://img.shields.io/github/stars/duosecurity/duo_ruby)](https://github.com/duosecurity/duo_ruby/stargazers)
[![License](https://img.shields.io/badge/License-View%20License-orange)](https://github.com/duosecurity/duo_ruby/blob/master/LICENSE)
**duo_ruby** - Duo two-factor authentication for Ruby web applications: https://duo.com/docs/duoweb-v2

This package allows a web developer to quickly add Duo's interactive, self-service, two-factor authentication to any web login form - without setting up secondary user accounts, directory synchronization, servers, or hardware.

What's here:

* `js` - Duo Javascript library, to be hosted by your webserver.
* `lib/duo_web.rb` - Duo Ruby SDK to be integrated with your web application
* `test/test_duo_web.rb` -  Unit tests for our SDK

# Installing

Development:

```
$ git clone https://github.com/duosecurity/duo_ruby.git
$ cd duo_ruby
```

System:

```
$ gem install duo_web
```

Or add the following to your project:

```
gem 'duo_web', '~> 1.0'
```

# Using

```
$ irb -r ./lib/duo_web.rb
irb(main):001:0> Duo.sign_request(ikey, skey, akey, username)
=> "TX|...TX_SIGNATURE...==|...TX_HASH...:APP|...APP_SIGNATURE...==|...APP_HASH..."
```

# Demo

* [Setup WebSDK integration](https://duo.com/docs/duoweb)
* [Install Thin webserver](https://github.com/macournoyer/thin)

```
$ gem install thin
```

* Configure `server.rb` with `host`, `ikey`, `skey`, `akey`, and `username` from your WebSDK integration

```
class DuoLoginAdapter
  def initialize
    @host = 'yournamehere.duosecurity.com'
    @ikey = 'aaaaaaaaaaaaaaaaaaaa'
    @skey = 'vDMdvfJAo6Mhb4ZEuQzNXRe2MvrzXD9qYnpbhOZK'
    @akey = 'vDMdtfQUo6Mhb4JEuQzNXRe0MvszXD9qYnpbh1PZ'
    @username = 'your_duo_username'
    ...
```

* Start the demo

```
$ ruby server.rb
```

# Testing

```
$ rake
Loaded suite /usr/lib/ruby/vendor_ruby/rake/rake_test_loader
Started
..

Finished in 0.001006152 seconds.
---------------------------------------------------------------------------------------
2 tests, 13 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
100% passed
---------------------------------------------------------------------------------------
1987.77 tests/s, 12920.51 assertions/s
```

# Linting

```
$ rubocop
```

# Support

Report any bugs, feature requests, etc. to us directly: support@duosecurity.com
