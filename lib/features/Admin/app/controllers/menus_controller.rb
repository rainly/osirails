class MenusController < ApplicationController
  
  # GET /menus
  def index
    # get_structured_menus permit to make a indent for menu's list
    @menus = Menu.get_structured_menus("<span class='admin_menus_indent'/>") #FIXME Manage CSS for indent
  end
  
  # GET /menus/new
  def new
    @menu = Menu.new
    # get_structured_menus permit to make a indent for menu's list
    @menus = Menu.get_structured_menus("---")
  end
  
  # POST /menus
  def create
    @menu = Menu.new(params[:menu])
    # get_structured_menus permit to make a indent for menu's list
    @menus = Menu.get_structured_menus("----")
    if @menu.save
      flash[:notice] = 'Votre menu est créée avec succes'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end
  
  # GET /menu/1/edit
  def edit
    @menu = Menu.find(params[:id])
    # get_structured_menus permit to make a indent for menu's list
    @menus = Menu.get_structured_menus("---")
  end
  
  # can_has_this_parent? => Permit to check if the new parent can has this parent
  # change_parent => method to change parent
  # 
  # PUT /menus/1
  def update
    # get_structured_menus permit to make a indent for menu's list  
    @menus = Menu.get_structured_menus("----")
    @menu = Menu.find(params[:id])
    parent_id =params[:menu].delete(:parent_id)
    if @menu.can_has_this_parent?(parent_id)          
      if @menu.update_attributes(params[:menu])
        @menu.change_parent(parent_id)
        redirect_to menus_path
      else
        flash[:error] = "Erreur lors de la mise à jour de la menu" 
        render :action => 'edit'
      end
    else
      flash[:error] = "Déplacement impossible"
      redirect_to :back
    end
  end
  
  # This method permit to move up a menu.
  def move_up
    menu = Menu.find_by_id(params[:id])
    menu.move_higher
    redirect_to menus_path
  end
  
  # This method permit to move down a menu.
  def move_down
    menu = Menu.find_by_id(params[:id])
    menu.move_lower
    redirect_to menus_path
  end
  
  # DELETE /menus/1
  def destroy
    menu = Menu.find_by_id(params[:id])
    if menu.can_delete?
      if menu.destroy
        flash[:notice] = "Menu supprimer avec succes"
      else 
        flash[:error] = "La suppression de la menu a échouée"
      end
    else 
      flash[:error] = "Cette menu n'est pas supprimable"
    end
    redirect_to menus_path
  end 
end
