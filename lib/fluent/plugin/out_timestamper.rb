module Fluent
  class Timestamper < Output
    Fluent::Plugin.register_output('timestamper', self)

    config_param :tag, :string

    def configure(conf)
      super
    end

    def filter_stream(tag, es)
      es.each do |time, record|
        p time, record
      end
    end
  end
end
