require File.join(RAILS_ROOT, 'lib', 'initialize_feature.rb')
init(config, directory, "has_search_index")


require 'has_search_index/view_helpers'
require 'has_search_index_methods_helper'
require 'has_search_index'
