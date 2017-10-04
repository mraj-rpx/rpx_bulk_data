class Api::V1::DocumentsController < ApplicationController
  include RequestLogger

  before_action :authenticate_user!
  before_action :set_s3_downloader

  def index
    render json: {available_documents: @s3_downloader.available_documents}
  end

  def download
    render json: {document_url: @s3_downloader.document_presigned_url, message: "This url is valid for #{ENV['S3_URL_EXPIRES_IN']} seconds. After that generate new one."}
  end

  private

  def set_s3_downloader
    @s3_downloader = S3Downloader.new(current_user, params.permit(:s3_key))
  end
end
