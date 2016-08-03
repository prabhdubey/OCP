class BlogsController < ApplicationController
  before_action :set_blog, only: [:show, :edit, :update, :destroy]

  # GET /blogs
  # GET /blogs.json
  def index

    @comments=Comment.order("id DESC").all
    @blog = Blog.includes(:comments).find_by(id: params[:id])
    if params[:title].present?
      @blogs = Blog.where(flag: true).search(params[:title]).order("created_at DESC")
    else
      @blogs = Blog.where(flag: true)
      @blogs = Blog.where(flag: true).search(params[:title]).order("created_at DESC")
    end
    # @blogs = current_user.college.blogs
    # @blogs = Blog.joins(:user => [:college]).where("college_name = ?". current_user.college_name)
  end

  def draft
    @comments=Comment.all
    if params[:title].present?
      @blogs = Blog.where(user_id: current_user.id, flag: false).search(params[:title])
    else
      @blogs = Blog.where(user_id: current_user.id, flag: false)
    end
    # @blogs = current_user.college.blogs
    # @blogs = Blog.joins(:user => [:college]).where("college_name = ?". current_user.college_name)
  end

  # GET /blogs/1
  # GET /blogs/1.json
  def show
    @blog = Blog.includes(:comments).find_by(id: params[:id])
    @blog.increment!(:views)
    # @blog
    @comments = @blog.comments 
    @comment = Comment.new
  end

  # GET /blogs/new
  def new
    @blog = Blog.new
  end

  # GET /blogs/1/edit
  def edit
  end

  # POST /blogs
  # POST /blogs.json
  def create
    @blog = Blog.new(blog_params)
    @blog.user_id = current_user.id
    @blog.author = current_user.first_name

    respond_to do |format|
      if @blog.save
        format.html { redirect_to @blog, notice: 'Blog was successfully created.' }
        format.json { render :show, status: :created, location: @blog }
      else
        format.html { render :new }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blogs/1
  # PATCH/PUT /blogs/1.json
  def update
    respond_to do |format|
      if @blog.update(blog_params)
        format.html { redirect_to @blog, notice: 'Blog was successfully updated.' }
        format.json { render :show, status: :ok, location: @blog }
      else
        format.html { render :edit }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blogs/1
  # DELETE /blogs/1.json
  def destroy
      @blog.destroy
        respond_to do |format|
          format.html { redirect_to blogs_url, notice: 'Blog was successfully destroyed.' }
          format.json { head :no_content }
        end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog
      @blog = Blog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blog_params
      params.require(:blog).permit(:title, :image, :body, :flag)
    end
end
