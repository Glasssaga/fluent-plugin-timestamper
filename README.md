# fluent-plugin-timestamper

Fluentd output plugin which adds timestamp field to record.
Timestamp format can be seconds and milliseconds from epoch, iso8601 and you can also use strftime() format.

## Installation

    $ gem install fluent-plugin-timestamper

## Usage

Put your configuration in /etc/fluent/fluent.conf

```xml:fluent.conf
<match foo>
  type timestamper
  tag tag.to.rewrite
  key name_of_key
  format milliseconds # or "seconds", "iso8601", "%Y-%m-%d"
</match>
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/fluent-plugin-timestamper/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
