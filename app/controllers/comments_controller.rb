class CommentsController < ApplicationController
  before_action :set_comment, only: %i[destroy edit update]

  def create
    comment = current_user.comments.build(comment_params)
    if comment.save
      redirect_to sheet_path(comment.sheet), success: t('defaults.message.created', item: Comment.model_name.human)
    else
      redirect_to sheet_path(comment.sheet), danger: t('defaults.message.not_created', item: Comment.model_name.human) + "(#{comment.errors.full_messages.join(', ')})"
    end
  end

  def destroy
    @comment.destroy!
    redirect_to sheet_path(@comment.sheet), success: t('defaults.message.deleted', item: Comment.model_name.human)
  end

  def edit; end

  def update
    if @comment.update(comment_update_params)
      redirect_to sheet_path(@comment.sheet), success: t('defaults.message.updated', item: Comment.model_name.human)
    else
      flash.now['danger'] = t('defaults.message.not_updated', item: Comment.model_name.human)
      render :edit
    end
  end

  private

  def set_comment
    @comment = current_user.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, :embed_type, :identifier).merge(sheet_id: params[:sheet_id])
  end

  def comment_update_params
    params.require(:comment).permit(:body, :embed_type, :identifier)
  end
end
