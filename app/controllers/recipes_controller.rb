class RecipesController < ApplicationController
    before_action :require_login
    
    def index
        @your_recipes = Recipe.where(user_id: current_user.id)
        @public_recipes = Recipe.where.not(user_id: current_user.id)
    end

    def most_popular
        @recipe = Recipe.most_popular
        render "most_popular_recipe"
    end

    def show
        @recipe = Recipe.find(params[:id])
    end

    def new
        @recipe = Recipe.new
    end

    def create 
        @recipe = Recipe.create(
            user: current_user, 
            name: recipe_params[:name], 
            directions: recipe_params[:directions]
            )
        @recipe.add_items(recipe_params)
        if @recipe.errors.any?
            flash[:error_messages] = @recipe.errors.full_messages
            redirect_to new_recipe_path # render causes error message to show on next page also
        else
            redirect_to recipe_path(@recipe)
        end
    end

    def edit
        @recipe = Recipe.find(params[:id])
        redirect_hacker(@recipe, recipes_path)
    end

    def update
        @recipe = Recipe.find(params[:id])
        @recipe.update_recipe(recipe_params)
        if @recipe.errors.any?
            flash[:error_messages] = @recipe.errors.full_messages
            redirect_to edit_recipe_path(@recipe) # render causes error message to show on next page also
        else
            redirect_to recipe_path(@recipe)
        end
    end

    def destroy 
        Recipe.find(params[:id]).destroy
        redirect_to recipes_path
    end

    private
    def recipe_params
        params.require(:recipe).permit(:name, :directions, recipe_items_attributes: [:quantity, :name]).to_h
    end 
end
