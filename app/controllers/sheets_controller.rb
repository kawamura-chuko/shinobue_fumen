class SheetsController < ApplicationController
  before_action :set_sheet, only: %i[ show update destroy ]

  def index
    @sheets = Sheet.all
  end

  def show
  end

  def update
    if @sheet.update(sheet_params)
      redirect_to @sheet, notice: "Sheet was successfully updated."
    else
      redirect_to @sheet, alert: "入力してください"
    end
  end

  private

  def set_sheet
    @sheet = Sheet.find(params[:id])
  end

  def sheet_params
    params.require(:sheet).permit(:title, :level, :comma_joined_mml)
  end
end
