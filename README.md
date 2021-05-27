# rb-bitly
A ruby bitly url wrapper made in ruby

[![forthebadge](https://forthebadge.com/images/badges/made-with-ruby.svg)](https://forthebadge.com)

# Installation
```
git clone https://github.com/krishpranav/rb-bitly
cd rb-bitly
bundle instal
```

# Shorten link
```ruby
bitlink = client.shorten(long_url: "http://example.com")
bitlink.link
# output: http://bit.ly/ds4320
```

# Expand a link
```ruby
bitlink = client.expand(bitlink: "http://bit.ly/ds4320")
bitlink.long_url
# output: http://example.com
```
