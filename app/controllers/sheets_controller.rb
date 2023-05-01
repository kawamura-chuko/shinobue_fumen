class SheetsController < ApplicationController
  before_action :set_sheet, only: %i[ show update destroy ]

  def index
    @sheets = Sheet.all
  end

  def show
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

  def set_sheet
    @sheet = Sheet.find(params[:id])
  end

  def sheet_params
    params.require(:sheet).permit(:title, :level, :comma_joined_mml)
  end
end
