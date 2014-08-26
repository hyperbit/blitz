OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '1517142275185874', 'b4667e4766a1d18867317ef279812b25'
end