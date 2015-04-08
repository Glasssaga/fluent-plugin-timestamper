module Fluent
  class Timestamper < Output
    Fluent::Plugin.register_output('timestamper', self)

    config_param :tag, :string
    config_param :key, :string
    config_param :format, :string
    config_param :source, :string, :default => "now"

    def configure(conf)
      super
      case @source
      when "now"
        @time_getter = method(:get_time_now)
      when "record"
        @time_getter = method(:get_time_record)
      else
        raise ConfigError, "timestamper: Unknown source : " + @source
      end
    end

    def emit(tag, es, chain)
      es.each do |time, record|
        the_time = @time_getter.call(time)
        case @format
        when "seconds"
          record[@key] = the_time.to_i
        when "milliseconds"
          record[@key] = (the_time.to_i * 1000) + (the_time.usec / 1000.0).round
        when "iso8601"
          record[@key] = the_time.iso8601
        else
          record[@key] = the_time.strftime(@format)
        end

        Fluent::Engine.emit(@tag, time, record)
      end

      chain.next
    end

    private 
    def get_time_now(record_time)
      return Time.now
    end

    def get_time_record(record_time)
      return Time.at(record_time).utc
    end
  end
end
