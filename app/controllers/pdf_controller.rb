class PdfController < ApplicationController

  def make
    url = URI.parse(params[:url])
    filename = params[:filename] || url.host
    pdf = Rails.cache.fetch(url.to_s,force: params[:refresh].present?) do
      WickedPdf.new.pdf_from_url(url.to_s)
    end
    send_data pdf,filename: "#{filename}.pdf" , :type => "application/pdf;charset=utf-8; header=present"
  end
end
