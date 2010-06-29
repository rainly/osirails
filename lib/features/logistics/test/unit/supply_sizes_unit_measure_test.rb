require File.dirname(__FILE__) + '/../logistics_test'

class SupplySizesUnitMeasureTest < ActiveSupport::TestCase
  should_belong_to :supply_size, :unit_measure
  should_validate_presence_of :supply_size, :unit_measure, :with_foreign_key => :default
end
