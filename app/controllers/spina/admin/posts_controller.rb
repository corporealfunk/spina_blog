module Spina
  module Admin
    class PostsController < AdminController
      before_action :set_breadcrumb
      before_action :set_post, only: [:edit, :update, :destroy]
      before_action :set_tabs

      layout 'spina/admin/admin'

      def index
        @posts = Post.all
      end

      def new
        add_breadcrumb 'New Post', new_admin_post_path
        @post = Post.new
      end

      def edit
      end

      def create
        add_breadcrumb 'New Post', new_admin_post_path
        @post = Post.new(post_params)
        @post.author = current_spina_user
        if @post.save
          redirect_to admin_posts_path, notice: 'Post was successfully created.'
        else
          render :new
        end
      end

      def update
        if @post.update(post_params)
          redirect_to admin_posts_path, notice: 'Post was successfully updated.'
        else
          render :edit
        end
      end

      def destroy
        @post.destroy
        redirect_to admin_posts_path, notice: 'Post was successfully destroyed.'
      end

      private

      def post_params
        incoming = params.require(:post).permit(:title, :body, :tag_list, :is_draft, :timezone, :materialized_path)

        publish_date = params[:post][:publish_date].present? ? params[:post][:publish_date] : nil
        publish_time = params[:post][:publish_time].present? ? params[:post][:publish_time] : nil
        incoming.merge(
          publish_date: publish_date,
          publish_time: publish_time,
        )
      end

      def set_breadcrumb
        add_breadcrumb 'Posts', admin_posts_path
      end

      def set_tabs
        @tabs = %w{content advanced}
      end

      def set_post
        @post = Post.find(params[:id])
        add_breadcrumb @post.title
      end
    end
  end
end
