# frozen_string_literal: true

module Web
  class RepositoriesController < Web::ApplicationController
    before_action :authenticate_user!

    def index
      @repositories = current_user.repositories.includes(:checks)
    end

    def show
      @repository = Repository.find(params[:id])
      authorize @repository

      @checks = @repository.checks.latest
    end

    def new
      @repository = current_user.repositories.build
      authorize @repository

      @github_client = ApplicationContainer[:github_client].new(@repository, current_user)

      @repositories = @github_client.filtered_by_languages_repos.map { |repo| [repo[:full_name], repo[:id]] }
    end

    def create
      @repository = current_user.repositories.find_or_initialize_by(repository_params)
      authorize @repository

      if @repository.save
        RepositoryLoadInfoJob.perform_later(@repository.id)

        flash[:notice] = t('flash.repositories.create.success')
        redirect_to repositories_path
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def repository_params
      params.require(:repository).permit(:github_id)
    end
  end
end
