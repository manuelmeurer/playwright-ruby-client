module Playwright
  module JavaScript
    class Function
      def initialize(definition, arg)
        @definition = definition
        @serialized_arg = ValueSerializer.new(arg).serialize
      end

      def evaluate(channel)
        value = channel.send_message_to_server(
          'evaluateExpression',
          expression: @definition,
          arg: @serialized_arg,
        )
        ValueParser.new(value).parse
      end

      def evaluate_handle(channel)
        resp = channel.send_message_to_server(
          'evaluateExpressionHandle',
          expression: @definition,
          arg: @serialized_arg,
        )
        ::Playwright::ChannelOwner.from(resp)
      end

      def eval_on_selector(channel, selector)
        value = channel.send_message_to_server(
          'evalOnSelector',
          selector: selector,
          expression: @definition,
          arg: @serialized_arg,
        )
        ValueParser.new(value).parse
      end

      def eval_on_selector_all(channel, selector)
        value = channel.send_message_to_server(
          'evalOnSelectorAll',
          selector: selector,
          expression: @definition,
          arg: @serialized_arg,
        )
        ValueParser.new(value).parse
      end

      def wait_for_function(channel, polling:, timeout:)
        params = {
          expression: @definition,
          arg: @serialized_arg,
          polling: polling,
          timeout: timeout,
        }.compact
        if polling.is_a?(Numeric)
          params[:pollingInterval] = polling
        end
        resp = channel.send_message_to_server('waitForFunction', params)
        ChannelOwners::JSHandle.from(resp)
      end
    end
  end
end
