class PdfController < ApplicationController

  def make
    pdf = WickedPdf.new.pdf_from_url(params[:url])

    send_data pdf,filename: , :type => "application/pdf"
  end
end
