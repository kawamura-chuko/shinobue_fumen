class SheetsController < ApplicationController
  before_action :set_sheet, only: %i[ show update destroy ]
  before_action :set_types_of_selectable_levels

  def index
    @sheets = Sheet.all
  end

  def new
    @sheet = Sheet.new(level_params)
    @sheet[:title] = '無題'
    @sheet[:comma_joined_mml] = @sheet.make_music(@sheet[:level])
  end

  def show
  end

  def create
    @sheet = Sheet.new(sheet_params)
    if @sheet.save
      redirect_to @sheet, success: t('.success')
    else
      flash.now['danger'] = @sheet.errors.full_messages.join(", ")
      render :new
    end
  end

  def update
    if @sheet.update(sheet_params)
      redirect_to @sheet, success: t('.success')
    else
      redirect_to @sheet, danger: @sheet.errors.full_messages.join(", ")
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

  def set_types_of_selectable_levels
    @level = Sheet.types_of_selectable_levels
  end

  def set_sheet
    @sheet = Sheet.find(params[:id])
  end

  def sheet_params
    params.require(:sheet).permit(:title, :level, :comma_joined_mml)
  end
end
