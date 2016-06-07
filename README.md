# Overview

**duo_ruby** - Duo two-factor authentication for Ruby web applications: https://duo.com/docs/duoweb

This package allows a web developer to quickly add Duo's interactive, self-service, two-factor authentication to any web login form - without setting up secondary user accounts, directory synchronization, servers, or hardware.

What's here:

* `js` - Duo Javascript library, to be hosted by your webserver.
* `duo_web.rb` - Duo Ruby SDK to be integrated with your web application
* `test.rb` -  Unit tests for our SDK

# Installing

```
$ git clone https://github.com/duosecurity/duo_ruby.git
```

# Using

```
$ irb -r ./duo_web.rb
irb(main):001:0> Duo.sign_request(ikey, skey, akey, username)
=> "TX|...TX_SIGNATURE...==|...TX_HASH...:APP|...APP_SIGNATURE...==|...APP_HASH..."
```

# Testing

```
$ ruby test.rb
Loaded suite test
Started
..

Finished in 0.001666831 seconds.
---------------------------------------------------------------------------------------
2 tests, 13 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
100% passed
---------------------------------------------------------------------------------------
1199.88 tests/s, 7799.23 assertions/s
```

# Linting

```
$ rubocop duo_web.rb
```

# Support

Report any bugs, feature requests, etc. to us directly: support@duosecurity.com
