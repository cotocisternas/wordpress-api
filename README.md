# WordpressApi

This gem is used as a ruby interface wrapper for the Wordpress Rest v2 Api.  

This gem implements the [WordPress REST V2 API](https://developer.wordpress.org/rest-api/reference/) as released in version 2.0-beta15.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wordpress_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wordpress_api

## Usage

Create a new client in the `config` folder.

```
require 'wordpress_api'

WordpressApi.configure do |config|
  config.endpoint = 'https://www.your_wordpress_site.com/wp-json/wp'
  config.username = 'username'
  config.password = 'password'
end
```

Making requests are simple:

```
WordpressApi.get(endpoint: :posts)

WordpressApi.get(endpoint: :posts, id: 4)

...
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Pull requests welcome [here](https://github.com/Jennifer/wordpress_api). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

If you'd like to contribute:

* Check out the latest version.
* Start a feature branch starting with the name `bug-`.
* Commit your changes and make sure you've added tests.
* Submit the pull request.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

##### Note: The development of this ruby gem is still in progress.
