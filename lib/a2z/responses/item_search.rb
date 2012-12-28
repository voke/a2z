module A2z
  module Responses
    class ItemSearch
      attr_accessor :operation_request, :items, :total_results, :total_pages, :more_search_results_url, :valid
      
      def initialize
        @items = []
        @total_results = 0
        @total_pages = 0
        @valid = true
      end
      
      def valid?
        @valid
      end
      
      def valid=(value)
        @valid = !!value
      end
      
      # TODO capture item_search_response['Items']['Request']['Errors'] into an attr_accessor value
      # TODO consider capturing item_search_response['Items']['Request'] into an attr_accessor value
      def self.from_response(data)
        new.tap do |item_search|
          item_search.operation_request       = OperationRequest.from_response(data['OperationRequest']) if data['OperationRequest']
          item_search.items                   = items_from_response(data)
          item_search.total_results           = data['Items']['TotalResults'].to_i rescue 0
          item_search.total_pages             = data['Items']['TotalPages'].to_i rescue 0
          item_search.more_search_results_url = data['Items']['MoreSearchResultsUrl'] rescue nil
          item_search.valid                   = data['Items']['Request']['IsValid'] == 'True' rescue false
          item_search.freeze
        end
      end
      
      private
      
      def self.items_from_response(data)
        items = data['Items']['Item'] rescue []
        items = [items].compact unless items.kind_of?(Array)
        items.collect { |item| Item.from_response(item) }
      end
    end
  end
end
