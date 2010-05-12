class HeadOffice < Establishment
  has_contacts
  
  has_search_index :only_attributes    => [ :name, :activated ],
                   :only_relationships => [ :customer, :activity_sector_reference, :establishment_type, :contacts, :address, :phone, :fax ],
                   :main_model         => true
end
