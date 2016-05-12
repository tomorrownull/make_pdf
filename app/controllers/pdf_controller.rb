class PdfController < ApplicationController

  def make
    url = URI.parse(get_params[:url])
    filename = get_params[:filename] || url.host
    MakePdfJob.perform_later(url.to_s,filename)
    render status: 200
  end

  protected

  def get_params
    params.require(:url)
    params
  end
end
