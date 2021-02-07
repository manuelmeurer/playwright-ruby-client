module Playwright
  module Utils
    module PrepareBrowserContextOptions
      # @see https://github.com/microsoft/playwright/blob/5a2cfdbd47ed3c3deff77bb73e5fac34241f649d/src/client/browserContext.ts#L265
      private def prepare_browser_context_options(params)
        if params[:viewport] == 0
          params.delete(:viewport)
          params[:noDefaultViewport] = true
        end
        if params[:extraHTTPHeaders]
          # TODO
        end
        if params[:storageState].is_a?(String)
          params[:storageState] = JSON.parse(File.read(params[:storageState]))
        end

        params
      end
    end

    module Errors
      module SafeCloseError
        # @param err [Exception]
        private def safe_close_error?(err)
          return true if err.is_a?(Transport::AlreadyDisconnectedError)

          [
            'Browser has been closed',
            'Target page, context or browser has been closed',
          ].any? do |closed_message|
            err.message.end_with?(closed_message)
          end
        end
      end
    end
  end
end