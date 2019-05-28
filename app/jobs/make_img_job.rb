class MakeImgJob < ApplicationJob
  include Progress
  queue_as :image

  def perform(urls, zip_filename)
    temp_dir = "/tmp/#{zip_filename}"
    if Dir.exist?(temp_dir)
      FileUtils.rm_f Dir.glob("#{temp_dir}/*")
      Dir.delete(temp_dir)
    end

    Dir.mkdir(temp_dir)
    commands = []
    commands << 'wkhtmltoimage'
    commands << '--width 0'
    commands << '--enable-smart-width'
    commands << '--enable-smart-width'

    urls.each do |url_str|
      url = URI.parse(url_str)
      full_filename = "#{temp_dir}/#{Rack::Utils.parse_query(url.query).fetch('filename', url.to_s)}.png"
      invoke_with_progress(commands + [url, full_filename], {})
    end
    ZipFileGenerator.new(temp_dir, Rails.root.join('public', "#{zip_filename}.zip")).write
  end
end
