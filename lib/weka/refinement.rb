module Weka
  module Refinement
    refine Array do
      # Map an array of attributes into their indices in an Instances.
      #   can be invoked on Array<String>, Array<Symbol>
      #
      # @param [Instances] instances
      #
      # @return [Array<Integer>] array of the corresponding indices
      #
      # @example invoke on an array of attribute names in strings
      #   ['name', 'age', 'title'].to_weka_attribute_indices(instances)
      #
      # @example invoke on an array of attribute names in symbols
      #   [:name, :age, :title].to_weka_attribute_indices(instances)
      #
      # @note for non-existent attribute its index is -1
      def instances_indices(instances)
        map do |attr_name|
          unless attr_name.is_a?(String) || attr_name.is_a?(Symbol)
            raise "cannot map attribute specified with #{attr_name} into index"
          end

          attr = instances.attribute(attr_name.to_s)
          attr.nil? ? -1 : attr.index
        end
      end
    end
  end
end
