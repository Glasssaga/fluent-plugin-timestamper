require 'helper'
require 'timecop'

class TimestamperOutputTest < Test::Unit::TestCase
  def setup
    @time = Time.parse("2011-01-02 13:14:15 UTC")
    @tag = "foo"
    @key = "timestamp"
    Timecop.freeze(@time)
    Fluent::Test.setup
  end

  def create_driver(conf, tag='test')
    Fluent::Test::OutputTestDriver.new(Fluent::Timestamper, tag).configure(conf)
  end

  def test_format_seconds
    d = create_driver %[
      tag #{@tag}
      key #{@key}
      format seconds
    ]

    seconds = @time.to_i
    timestamp = pick_timestamp(d)
    assert_equal seconds, timestamp
  end

  def test_format_milliseconds
    d = create_driver %[
      tag #{@tag}
      key #{@key}
      format milliseconds
    ]

    milliseconds = (@time.to_i * 1000) + (@time.usec / 1000.0).round
    timestamp = pick_timestamp(d)
    assert_equal milliseconds, timestamp
  end

  def test_format_iso8601
    d = create_driver %[
      tag #{@tag}
      key #{@key}
      format iso8601
    ]

    iso8601 = Time.now.iso8601
    timestamp = pick_timestamp(d)
    assert_equal iso8601, timestamp
  end

  def test_format_strftime
    d = create_driver %[
      tag #{@tag}
      key #{@key}
      format %X
    ]

    formatted = Time.now.strftime("%X")
    timestamp = pick_timestamp(d)
    assert_equal formatted, timestamp
  end

  private

  def pick_timestamp(d)
    d.run do
      d.emit({"a"=>1}, @time.to_i)
    end

    record = d.emits.first.last
    return record[@key]
  end

  def teardown
    Timecop.return
  end
end
