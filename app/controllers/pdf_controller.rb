class PdfController < ApplicationController

  def make
    url = URI.parse(params[:url])
    filename = params[:filename] || url.host
    pdf = Rails.cache.fetch(url.to_s,force: params[:refresh].present?) do
      WickedPdf.new.pdf_from_url(url.to_s)
    end
    save_path = Rails.root.join('public/pdfs',"#{filename}.pdf")
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
    send_file save_path, :type => "application/pdf;charset=utf-8; header=present"
  end
end
