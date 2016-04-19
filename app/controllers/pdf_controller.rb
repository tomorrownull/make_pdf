class PdfController < ApplicationController

  def make
    pdf = WickedPdf.new.pdf_from_url(params[:url])
    url = URI.parse(params[:url])
    filename = params[:filename] || url.host
    send_data pdf,filename: "#{filename}.pdf" , :type => "application/pdf"
  end
end
