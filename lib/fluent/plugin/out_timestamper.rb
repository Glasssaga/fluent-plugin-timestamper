module Fluent
  class Timestamper < Output
    Fluent::Plugin.register_output('timestamper', self)

    config_param :tag, :string
    config_param :key, :string
    config_param :format, :string

    def configure(conf)
      super
    end

    def emit(tag, es, chain)
      now = Time.now

      es.each do |time, record|
        case @format
        when "seconds"
          record[@key] = now.to_i
        when "milliseconds"
          record[@key] = (now.to_i * 1000) + (now.usec / 1000.0).round
        when "iso8601"
          record[@key] = now.iso8601
        else
          record[@key] = now.strftime(@format)
        end

        Fluent::Engine.emit(@tag, time, record)
      end

      chain.next
    end
  end
end
