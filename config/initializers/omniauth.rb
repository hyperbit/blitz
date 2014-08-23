OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '1517142275185874', 'b69b2474d3c149940a3c08ef83950800'
end