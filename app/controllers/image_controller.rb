class ImageController < ApplicationController
  def create

    filename = get_params[:filename] || url.host
    MakeImgJob.perform_later(get_params[:urls], filename)
    render status: 200
  end



  protected

  def get_params
    params.require(:urls)
    params
  end
end
