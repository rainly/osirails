require 'test/test_helper'
require File.dirname(__FILE__) + '/supply_test'
require File.dirname(__FILE__) + '/create_supplies'
require File.dirname(__FILE__) + '/new_stock_flow'

class ConsumableTest < ActiveSupport::TestCase
  include SupplyTest
  include NewStockFlow
  
  def setup 
    @supply_category = ConsumableCategory.new(:name => "root")
    flunk "@supply_category should be valid" unless @supply_category.save    
    @supply = Consumable.new
    @supply.valid?   
  end  
  
  def test_presence_of_consumable_category_id
    assert @supply.errors.on(:consumable_category_id), "@supply should NOT be valid because consumable_category_id is nil"
    
    @supply.consumable_category_id = 0
    @supply.valid?
    assert !@supply.errors.on(:consumable_category_id), "@supply should be valid"
    assert @supply.errors.on(:supply_category), "@supply should be valid"
    
    @supply.consumable_category_id = @supply_category.id
    @supply.valid?
    assert !@supply.errors.on(:consumable_category_id), "@supply should be valid"
    assert !@supply.errors.on(:supply_category), "@supply should be valid"
    
    @supply.supply_category = @supply_category
    @supply.valid?
    assert !@supply.errors.on(:consumable_category_id), "@supply should be valid"
    assert !@supply.errors.on(:supply_category), "@supply should be valid"
  end
  
  include CreateSupplies
  
  def test_uniqueness_of_name
    create_consumables
    create_commodities
    @supply.name = "PVC"
    @supply.valid?
    
    assert @supply.errors.on(:name), "@supply should NOT be valid because name is already taken"
    
    @supply.name = "pvc"
    @supply.valid?
    
    assert !@supply.errors.on(:name), "@supply should be valid"
  end
  
  def test_uniqueness_of_reference
    create_consumables
    create_commodities
    @supply.reference = "pvc1234"
    @supply.valid?
    
    assert @supply.errors.on(:reference), "@supply should NOT be valid because reference is already taken"
    
    @supply.reference = "glv1234"
    @supply.valid?
    
    assert !@supply.errors.on(:reference), "@supply should be valid"
  end
  
  

  def test_restockables
    create_supplier_supplies
    assert_equal Consumable.restockables, Consumable.find(:all), "restockables are all supplies as their stock are 0 (under threshold*1.1)"

    flunk "stock flow must be saved" unless new_stock_flow(@pvc,@pvc_ss.supplier,true,10)
    sleep(1)
    
    assert_equal Consumable.restockables, Consumable.find(:all), "restockables are all supplies as their stock are 0 (under threshold*1.1)"
    
    flunk "stock flow must be saved" unless new_stock_flow(@pvc,@pvc_ss.supplier,true,3)
    sleep(1)
    
    assert_equal Consumable.restockables, Consumable.find(:all), "restockables are all supplies as their stock are 0 (under threshold*1.1)"
   
    flunk "stock flow must be saved" unless new_stock_flow(@pvc,@pvc_ss.supplier,true,12)
    
    assert Consumable.restockables != Consumable.find(:all), "restockables are NOT all supplies as @pvc is not a restockable anymore"
    assert !Consumable.restockables.include?(Consumable.find(@pvc.id)), "@pvc should NOT be included in restockables as its stock is 25 (above threshold*1.1)"
  end
  
  def test_has_supplier_supplies
    create_supplier_consumables    
    assert_equal @vis.supplier_supplies, [@vis_ss], "[@vis_ss] should be @vis.supplier_supplies"                                          
  end
  
  def test_has_supplies
    create_supplier_consumables
    assert_equal [Supplier.last], @vis.suppliers, "[Supplier.last] should be @vis.suppliers"
  end
end
