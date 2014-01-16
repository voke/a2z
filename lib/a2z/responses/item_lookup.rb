module A2z
  module Responses
    class ItemLookup
      attr_accessor :operation_request, :items

      def initialize
        @valid = true
      end

      def valid=(value)
        @valid = !!value
      end

      def valid?
        @valid
      end

      def item
        items.first
      end

      # TODO capture data['Items']['Request']['Errors'] into an attr_accessor value
      # TODO consider capturing data['Items']['Request'] into an attr_accessor value
      def self.from_response(data)
        new.tap do |item_lookup|
          item_lookup.operation_request = OperationRequest.from_response(data['OperationRequest']) if data['OperationRequest']
          item_lookup.items             = [data['Items']['Item']].flatten.map { |x| Item.from_response(x) } if data['Items'] && data['Items']['Item']
          item_lookup.valid             = data['Items']['Request']['IsValid'] == 'True' rescue false
          item_lookup.freeze
        end
      end
    end
  end
end
