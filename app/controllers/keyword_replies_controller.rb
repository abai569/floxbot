class KeywordRepliesController < ApplicationController
  before_action :set_keyword_reply, only: %i[ show edit update destroy ]

  def index
    @keyword_replies = KeywordReply.all

    if params[:group_name].present? && params[:group_name] != "all"
      @keyword_replies = @keyword_replies.joins(:group_config).where(group_configs: { group_name: params[:group_name] })
    end

    sort_by = params[:sort] || "created_at"
    sort_direction = params[:direction] || "desc"
    @keyword_replies = @keyword_replies.order("#{sort_by} #{sort_direction}")

    @per_page = (params[:per_page] || 10).to_i
    @per_page = 10 if @per_page < 1 || @per_page > 100

    @total_count = @keyword_replies.count
    @page = (params[:page] || 1).to_i
    @page = 1 if @page < 1

    offset = (@page - 1) * @per_page
    @keyword_replies = @keyword_replies.limit(@per_page).offset(offset)
    @total_pages = (@total_count.to_f / @per_page).ceil

    @group_names = GroupConfig.distinct.pluck(:group_name).compact.sort
  end

  def show
  end

  def new
    @keyword_reply = KeywordReply.new
  end

  def edit
  end

  def create
    @keyword_reply = KeywordReply.new(keyword_reply_params)

    respond_to do |format|
      if @keyword_reply.save
        format.html { redirect_to @keyword_reply, notice: "Keyword reply was successfully created." }
        format.json { render :show, status: :created, location: @keyword_reply }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @keyword_reply.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @keyword_reply.update(keyword_reply_params)
        format.html { redirect_to @keyword_reply, notice: "Keyword reply was successfully updated." }
        format.json { render :show, status: :ok, location: @keyword_reply }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @keyword_reply.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @keyword_reply.destroy!

    respond_to do |format|
      format.html { redirect_to keyword_replies_path, notice: "Keyword reply was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_keyword_reply
    @keyword_reply = KeywordReply.find(params[:id])
  end

  def keyword_reply_params
    params.require(:keyword_reply).permit(
      :group_id, :keyword, :reply_type, :reply_content, :reply_text,
      :is_regex, :is_exact
    )
  end

  def index_params
    params.permit(:group_name, :per_page, :sort, :direction, :page)
  end

  helper_method :index_params
end
