require 'test/test_helper'

class SupplierTest < ActiveSupport::TestCase
  
  #TODO
  # has_permissions :as_business_object
  
  should_have_one :iban
  
  should_belong_to :activity_sector_reference
  
  should_validate_presence_of :activity_sector_reference, :with_foreign_key => :default
  
  context "Thanks to 'has_contacts', a supplier" do
    setup do
      @contacts_owner = Supplier.first
    end
    
    include HasContactsTest
  end
  
end
