def init(yaml, config, path)
  begin
    # Load every file in the app directory
    controller_path = File.join(path, 'app', 'controllers')
    $LOAD_PATH << controller_path
    Dependencies.load_paths << controller_path
    config.controller_paths << controller_path
    model_path = File.join(path, 'app', 'models')
    $LOAD_PATH << model_path
    Dependencies.load_paths << model_path
    config.controller_paths << model_path
    ActionController::Base.append_view_path(File.join(path, 'app', 'views'))
    $LOAD_PATH << File.join(path, 'app', 'helpers')

    # These variables store the feature's configuration from his config.yml file 
    name = yaml['name']
    version = yaml['version']
    dependencies = yaml['dependencies']
    conflicts = yaml['conflicts']
    business_objects = yaml['business_objects']
    menus = yaml['menus']
    configurations = yaml['configurations']

    # This array store all menus in order than they will be displayed
    $menu_table ||= []
    $option_configuration = []

    feature = Feature.find_or_create_by_name_and_version(name, version)

    # Test if feature belongs to base of the application
    if path == directory 
      feature.installed = 1 
      feature.save
    end

    if Feature::FEATURES_NOT_ABLE_TO_DEACTIVATE.include?(feature.name)
      feature.activated = 1
      feature.save  
    end

    #Test of dependencies for this feature
    dependencies_hash = []
    unless dependencies.nil?
      dependencies.each_pair do |key,value|
        dependencies_hash << {:name => key, :version => value}
      end
    end
    feature.dependencies = dependencies_hash
    feature.save

    #Test of conflicts for this feature
    conflicts_hash = []
    unless conflicts.nil?
      conflicts.each_pair do |key,value|
        conflicts_hash << {:name => key, :version => value}
      end
    end
    feature.conflicts = conflicts_hash
    feature.save

    #Test of business Objects
    business_objects_array =  []
    unless business_objects.nil?
      business_objects.each do |business_object|
        business_objects_array << [business_object]
      end
      feature.business_objects = business_objects_array
      feature.save
    end

    roles_count = Role.count
    #Test if all permission for all business objects are present
    unless business_objects.nil?
      business_objects.each do |bo|
        unless BusinessObjectPermission.find_all_by_has_permission_type(bo).size == roles_count
          Role.find(:all).each do |role|
            BusinessObjectPermission.find_or_create_by_has_permission_type_and_role_id(bo, role.id)
          end
        end  
      end
    end
    

    #Test if all permission for all menus are present
    def menus_permisisons_verification(menus)
      roles_count = Role.count
      unless menus.nil?
        menus.each_pair do |key,value|
          p = Menu.find_by_name(key)
          unless p.nil?
            unless MenuPermission.find_all_by_menu_id(p.id).size == roles_count
              Role.find(:all).each do |role|
                if MenuPermission.find_by_menu_id_and_role_id(p.id, role.id).nil?
                  MenuPermission.create(:menu_id => p.id,:role_id =>role.id)
                end
              end
            end
          end
          unless value['children'].nil?
            menus_permisisons_verification(value['children'])
          end
        end
      end
    end

    menus_permisisons_verification(menus)


    # This method insert in $menu_table all feature's menus
    def menu_insertion(menus,parent_name)
      unless menus.nil?
        menus.each_pair do |key,value|
          $menu_table << {  :name => key, :title => value["title"], :description => value["description"], :parent => parent_name, :position => value["position"]}
          unless value["children"].nil?
            menu_insertion(value["children"], key)
          end
        end
      end
    end

    menu_insertion(menus,"")

    # This block insert into Database the menus that wasn't present 
    $menu_table.each do |menu_array|
      # Parent menu is create if it isn't in database 
      unless parent_menu = Menu.find_by_name(menu_array[:parent])
        parent_menu = Menu.create(:name => menu_array[:parent])
      end
      
      # Unless menu already exist
      unless menu_ = Menu.find_by_name(menu_array[:name])             
        m = Menu.create(:title =>menu_array[:title], :description => menu_array[:description], :name => menu_array[:name], :parent_id =>parent_menu.id)
        unless menu_array[:position].nil?
          m.insert_at(menu_array[:position])
          m.save
        end
      else
        # This block test if a menu isn't define with two different parent in many config file
        $menu_table.each do |menu_test|
          if menu_test[:name] == menu_array[:name]
            if (!menu_test[:position].nil? and !menu_array[:position].nil?) and (menu_test[:position] != menu_array[:position])
              puts " A Position conflict occured with menu '#{menu_array[:name]}'"
            end
            if menu_test[:parent] != menu_array[:parent]
              raise("Double Declaration menu : a parent conflict occured with menu '#{menu_array[:name]}' in file '#{path}/config.yml'")
            end
          end
        end
        
        # If menu option is not present in database
        if !menu_array[:title].nil? and menu_.title.nil?
          menu_.title = menu_array[:title]
          menu_.insert_at(menu_array[:position]) unless menu_array[:position].nil?
        end
        menu_.description = menu_array[:description] if !menu_array[:description].nil? and menu_.description.nil?
        
        menu_.save
      end    
    end


    # This method insert into Database  all features options that wasn't present
    unless configurations.nil?
      configurations.each_pair  do |key,value|
        Configuration.create(:name => name.downcase+"_"+key, :value => value["value"], :description => value["description"]) unless Configuration.find_by_name(name+"_"+key)
      end
    end
  rescue ActiveRecord::StatementInvalid => e
    puts "An error has occured in file '#{__FILE__}'. Please restart the server so that the application works properly. (error : #{e.message})"
  end
end
