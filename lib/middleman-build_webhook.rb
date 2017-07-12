require "middleman-core"

Middleman::Extensions.register :build_webhook do
  require "middleman-build_webhook/extension"
  MiddlemanBuildWebhook
end
