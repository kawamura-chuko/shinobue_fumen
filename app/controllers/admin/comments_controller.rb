class Admin::CommentsController < Admin::BaseController
  before_action :set_comment, only: %i[edit update show destroy]

  def index
    @comments = Comment.all.includes(:user, :sheet).order(created_at: :desc)
  end

  def edit; end

  def update
    if @comment.update(comment_params)
      redirect_to admin_comment_path(@comment), success: t('defaults.message.updated', item: Comment.model_name.human)
    else
      flash.now['danger'] = t('defaults.message.not_updated', item: Comment.model_name.human)
      render :edit
    end
  end

  def show; end

  def destroy
    @comment.destroy!
    redirect_to admin_comments_path, success: t('defaults.message.deleted', item: Comment.model_name.human)
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, :embed_type, :identifier)
  end
end
