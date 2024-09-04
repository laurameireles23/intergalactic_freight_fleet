# frozen_string_literal: true

class ResourcesController < ApplicationController
  def create
    resource = Resource.new(resource_params)

    if resource.save
      render json: resource, status: :created
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def resource_params
    params.require(:resource).permit(:name, :weight)
  end
end
