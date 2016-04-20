class PdfController < ApplicationController

  def make
    url = URI.parse(params[:url])
    filename = params[:filename] || url.host
    Rails.cache.remove(url.to_s) if params[:refersh]
    pdf = Rails.cache.fetch(url.to_s) do
      WickedPdf.new.pdf_from_url(url.to_s)
    end
    send_data pdf,filename: "#{filename}.pdf" , :type => "application/pdf"
  end
end
