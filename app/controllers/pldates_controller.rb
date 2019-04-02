class PldatesController < ApplicationController

  def index
    @q = current_user.pldates.ransack(params[:q])
    @pldates = @q.result(distinct: true).page(params[:page]).per(9)

  end

  def new
    @pldate = Pldate.new
  end

  def create
    @pldate = current_user.pldates.new(pldate_params)

    if @pldate.save
      logger.debug "pldate: #{@pldate.attributes.inspect}"
      redirect_to @pldate, notice: "登録しました"
    else
      render 'new'
    end
  end

  def show
    @pldate = current_user.pldates.find(params[:id])
  end


  def edit
    @pldate = current_user.pldates.find(params[:id])
  end

  def update
    pldate = current_user.pldates.find(params[:id])
    pldate.update!(pldate_params)
    redirect_to pldates_url, notice: "更新しました"
  end

  def destroy
    pldate = current_user.pldates.find(params[:id])
    pldate.destroy
    redirect_to pldates_url, notice: "削除しました"
  end

  private

  def pldate_params
    params.require(:pldate).permit(:name, :url, :title, pldates_attributes: [:id, :name, :url, :_destroy])
  end
end
