class MakePdfJob < ApplicationJob
  queue_as :default

  def perform(url,filename)
    pdf = WickedPdf.new.pdf_from_url(url.to_s)
    save_path = Rails.root.join('public/pdfs',"#{filename}.pdf")
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
  end
end
