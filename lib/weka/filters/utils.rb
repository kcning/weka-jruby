module Weka
  module Filters
    module Utils
      def self.included(base)
        base.class_eval do
          def filter(instances)
            set_input_format(instances)
            Filter.use_filter(instances, self)
          end
        end
      end
    end
  end
end
