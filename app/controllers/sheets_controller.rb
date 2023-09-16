class SheetsController < ApplicationController
  before_action :set_sheet, only: %i[update destroy]

  def index
    @sheets = Sheet.all
  end

  def new
    @sheet = Sheet.new(level_params)
    @sheet[:title] = t('defaults.untitled')
    @sheet[:comma_joined_mml] = @sheet.make_music(Sheet.levels[@sheet.level])
  end

  def show
    @sheet = Sheet.find(params[:id])
    @comment = Comment.new
    @comments = @sheet.comments.includes(:user).order(created_at: :desc)
  end

  def create
    @sheet = current_user.sheets.build(sheet_params)
    if @sheet.save
      redirect_to @sheet, success: t('defaults.message.saved', item: Sheet.model_name.human)
    else
      flash.now['danger'] = t('defaults.message.not_saved', item: Sheet.model_name.human) + "(#{@sheet.errors.full_messages.join(', ')})"
      @sheet[:title] = t('defaults.untitled')
      render :new
    end
  end

  def update
    if @sheet.update(sheet_params)
      redirect_to @sheet, success: t('defaults.message.updated', item: Sheet.human_attribute_name(:title))
    else
      redirect_to @sheet, danger: t('defaults.message.not_updated', item: Sheet.human_attribute_name(:title)) + "(#{@sheet.errors.full_messages.join(', ')})"
    end
  end

  def destroy
    @sheet.destroy!
    redirect_to sheets_path, success: t('.success')
  end

  private

  def level_params
    params.permit(:level)
  end

  def set_sheet
    @sheet = current_user.sheets.find(params[:id])
  end

  def sheet_params
    params.require(:sheet).permit(:title, :level, :comma_joined_mml)
  end
end
