class CommentsController < ApplicationController
  def create
    comment = current_user.comments.build(comment_params)
    if comment.save
      redirect_to sheet_path(comment.sheet), success: t('defaults.message.created', item: Comment.model_name.human)
    else
      redirect_to sheet_path(comment.sheet), danger: t('defaults.message.not_created', item: Comment.model_name.human)
    end
  end

  def destroy
    comment = current_user.comments.find(params[:id])
    comment.destroy!
    redirect_to sheet_path(comment.sheet), success: t('defaults.message.deleted', item: Comment.model_name.human)
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(sheet_id: params[:sheet_id])
  end
end
