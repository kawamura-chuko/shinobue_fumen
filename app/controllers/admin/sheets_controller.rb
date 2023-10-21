class Admin::SheetsController < Admin::BaseController
  before_action :set_sheet, only: %i[edit update show destroy]

  def index
    @sheets = Sheet.all.includes(:user, :comments).order(created_at: :desc)
    @comment_counts = {}
    @comment_youtube = {}
    @sheets.each do |sheet|
      @comment_counts[sheet.id] = sheet.comments.size
      @comment_youtube[sheet.id] = sheet.comments.find(&:youtube?)
    end
  end

  def edit; end

  def update
    if @sheet.update(sheet_params)
      redirect_to admin_sheet_path(@sheet), success: t('defaults.message.updated', item: Sheet.model_name.human)
    else
      flash.now['danger'] = t('defaults.message.not_updated', item: Sheet.model_name.human)
      render :edit
    end
  end

  def show; end

  def destroy
    @sheet.destroy!
    redirect_to admin_sheets_path, success: t('defaults.message.deleted', item: Sheet.model_name.human)
  end

  private

  def set_sheet
    @sheet = Sheet.find(params[:id])
  end

  def sheet_params
    params.require(:sheet).permit(:title, :level, :comma_joined_mml)
  end
end
