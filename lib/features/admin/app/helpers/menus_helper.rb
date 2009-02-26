module MenusHelper
  
  # This method permit to show or not show button for up menu
  def show_up_button(menu, first_menu)
    if controller.can_edit?(current_user)
    
      if menu.can_move_up? and !first_menu
        link_to(image_tag("/images/arrow_up_16x16.png", :alt =>"Monter", :title =>"Monter"), { :action => "move_up", :id => menu.id })
      else
        image_tag("/images/arrow_up_disable_16x16.png", :alt =>"Monter", :title =>"Monter")
      end
    end
  end
  
  # This method permit to show or not show button for down menu
  def show_down_button(menu, last_menu)
    if controller.can_edit?(current_user)
      if menu.can_move_down? and !last_menu
        link_to(image_tag("/images/arrow_down_16x16.png", :alt => "Descendre", :title => "Descendre"), { :action => "move_down", :id => menu.id })
      else
        image_tag("/images/arrow_down_disable_16x16.png", :alt => "Descendre", :title => "Descendre")
      end
    end
  end
  
  # This method permit to show or not show button for edit menu
  def show_edit_button(menu)
    if controller.can_edit?(current_user)
      link_to(image_tag("/images/edit_16x16.png", :alt => "Modifier", :title => "Modifier"), edit_menu_path(menu))
    end
  end
  
  # This method permit to show or not show button for delete menu
  def show_delete_button(menu)
    if controller.can_delete?(current_user)
      unless menu.base_item?
        link_to(image_tag("/images/delete_16x16.png", :alt =>"Supprimer", :title =>"Supprimer"), menu, {:method => :delete, :confirm => 'Etes vous sûr  ?' })
      else
        image_tag("/images/delete_disable_16x16.png", :alt =>"Supprimer", :title =>"Supprimer")
      end
    end
  end
  
  # This method permit to show or hide button for add menu
  def show_add_button(menu,txt="")
    if controller.can_add?(current_user)
      if menu == 'none'
        link_to(image_tag("/images/add_16x16.png", :alt => "Ajouter", :title => "Ajouter")+" #{txt}", new_menu_path)
      else
        link_to(image_tag("/images/add_16x16.png", :alt => "Ajouter un sous menu", :title => "Ajouter un sous menu")+" #{txt}", new_menu_path(:parent_menu_id => menu.id))
      end
    end
  end
  
  # This method permit to have a menu on <ul> type.
  def show_structured_menus(menus)
    list = []
    list << "<div class='hierarchic'><ul class=\"parent\">"
    list = get_children_menus(menus,list)
    list << "</ul></div>"
    list 
  end
  
  # This method permit to make a tree for menus
  def get_children_menus(menus,list)
    menus.each do |menu|
      first_menu = ( menus.first == menu ? true : false )
      last_menu = ( menus.last == menu ? true : false )
      list << "<li class=\"category\">#{menu.title}<span class=\"action\">#{show_up_button(menu, first_menu)} #{show_down_button(menu, last_menu)} #{show_add_button(menu)} #{show_edit_button(menu)} #{show_delete_button(menu)}</span></li>"
      if menu.children.size > 0
        list << "<ul>"
        get_children_menus(menu.children,list)
        list << "</ul>"
      end
    end
    list
  end
end
