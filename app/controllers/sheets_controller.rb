class SheetsController < ApplicationController
  before_action :set_sheet, only: %i[ show update destroy ]
  before_action :set_types_of_selectable_levels

  def index
    @sheets = Sheet.all
  end

  def new
    @sheet = Sheet.new(level_params)
    # 自動作曲はまだ未実装のため、仮データを設定
    @sheet[:title] = '無題'
    @sheet[:comma_joined_mml] = 'L4O5c,L4O5c,L2O5d,L4O5c,L4O5c,L2O5d,L4O5c,L4O5d,L4O5e-,L4O5d,L4O5c,L8O5d,L8O5c,L2O4a-,L4O4g,L4O4e-,L4O4g,L4O4a-,L4O4g,L8O4g,L8O4e-,L2O4d,L4O4g,L4O4a-,L8O5d,L8O5c,L4O4a-,L2O4g,L2O4g'
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
