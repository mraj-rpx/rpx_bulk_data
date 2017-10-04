class S3Downloader
  DEFAULT_THREAD_COUNT = 20
  DEFAULT_CHUNK_SIZE = 4096

  attr_reader :client, :s3_downloader

  def initialize(current_user, download_params = {})
    @user = current_user
    @s3_key = download_params[:s3_key]
    @s3_location = @user.document_location.s3_location
    @client = Aws::S3::Client.new
    @downloader = Aws::S3::FileDownloader.new(client: @client)
  end

  def available_documents
    objects = @client.list_objects({bucket: ENV['BUCKET'], prefix: @s3_location})
    objects.contents.map{ |object| object.key.split('/')[-1] }
  end

  def document_presigned_url
    signer = Aws::S3::Presigner.new
    presigned_url = signer.presigned_url(:get_object,
                                         bucket: ENV['BUCKET'],
                                         key: [@s3_location, @s3_key].join('/'),
                                         expires_in: ENV['S3_URL_EXPIRES_IN'].to_i)
    presigned_url
  end

  def download
    s3_key_path = [@s3_location, @s3_key].join('/')
    download_options = {
      thread_count: DEFAULT_THREAD_COUNT,
      chunk_size: DEFAULT_CHUNK_SIZE,
      bucket: ENV['BUCKET'],
      key: s3_key_path,
      mode: 'get_range'
    }
    path = Rails.root.join("public/#{ENV['BUCKET']}/#{s3_key_path}")
    dirname = File.dirname(path)
    FileUtils.mkdir_p(dirname) unless File.directory?(dirname)

    @downloader.download(path, download_options)
    path
  end
end
