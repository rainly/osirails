# Feature Admin
controller_path = File.join(directory, 'app', 'controllers')
$LOAD_PATH << controller_path
Dependencies.load_paths << controller_path
config.controller_paths << controller_path
ActionController::Base.append_view_path(File.dirname(__FILE__) + '/app/views/')