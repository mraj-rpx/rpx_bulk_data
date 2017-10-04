module RequestLogger
  extend ActiveSupport::Concern

  included do
    before_action :log_request_info
  end

  private

  def log_request_info
    request_info = {
      user_id: current_user.id,
      s3_key: params[:s3_key],
      request_method: request.env['REQUEST_METHOD'],
      remote_addr: request.env['REMOTE_ADDR'],
      http_host: request.env['HTTP_HOST'],
      http_authentication: request.env['HTTP_AUTHORIZATION'],
      http_user_agent: request.env['HTTP_USER_AGENT'],
      request_uri: request.env['REQUEST_URI'],
      http_version: request.env['HTTP_VERSION'],
      query_string: request.env['QUERY_STRING'],
    }
    RequestLog.create(request_info)
  end
end
