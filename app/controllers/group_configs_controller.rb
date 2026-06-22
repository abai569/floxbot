class GroupConfigsController < ApplicationController
  before_action :set_group_config, only: %i[ show edit update destroy ]

  def index
    @group_configs = GroupConfig.all

    sort_by = params[:sort] || "created_at"
    sort_direction = params[:direction] || "desc"
    @group_configs = @group_configs.order("#{sort_by} #{sort_direction}")

    @per_page = (params[:per_page] || 10).to_i
    @per_page = 10 if @per_page < 1 || @per_page > 100

    @total_count = @group_configs.count
    @page = (params[:page] || 1).to_i
    @page = 1 if @page < 1

    offset = (@page - 1) * @per_page
    @group_configs = @group_configs.limit(@per_page).offset(offset)
    @total_pages = (@total_count.to_f / @per_page).ceil
  end

  def show
  end

  def new
    @group_config = GroupConfig.new
  end

  def edit
  end

  def create
    @group_config = GroupConfig.new(group_config_params)

    respond_to do |format|
      if @group_config.save
        format.html { redirect_to @group_config, notice: "Group config was successfully created." }
        format.json { render :show, status: :created, location: @group_config }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @group_config.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @group_config.update(group_config_params)
        format.html { redirect_to @group_config, notice: "Group config was successfully updated." }
        format.json { render :show, status: :ok, location: @group_config }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @group_config.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @group_config.destroy!

    respond_to do |format|
      format.html { redirect_to group_configs_path, notice: "Group config was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_group_config
    @group_config = GroupConfig.find(params[:id])
  end

  def group_config_params
    params.require(:group_config).permit(
      :group_id, :group_name, :verification_mode, :verification_timeout,
      :welcome_text, :welcome_photo_id, :welcome_video_id, :welcome_buttons_json,
      :del_join, :del_leave, :del_forward, :del_keyword, :del_service,
      :alert_delete_delay, :keyword_delete_delay, :forward_delete_delay,
      :welcome_delete_delay, :language
    )
  end

  def index_params
    params.permit(:per_page, :sort, :direction, :page)
  end

  helper_method :index_params
end
