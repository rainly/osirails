class Commodity < ActiveRecord::Base
  has_permissions :as_business_object
  
  # Relationship
  belongs_to :commodity_category, :counter_cache => true
  
  # Name Scope
  named_scope :activates, :conditions => {:enable => true}
  
  # Validates
  validates_presence_of :name, :fob_unit_price, :unit_mass, :measure, :taxe_coefficient, :commodity_category_id
  validates_presence_of :commodity_category, :if => :commodity_category_id
  validates_numericality_of :fob_unit_price, :unit_mass, :measure, :taxe_coefficient

  cattr_reader :form_labels
  @@form_labels = Hash.new
  @@form_labels[:name] = "Désignation :"
  @@form_labels[:commodity_category] = "Appartient à :"
  @@form_labels[:supplier] = "Fournisseur :"
  @@form_labels[:unit_mass] = "kg / U :"
  @@form_labels[:fob_unit_price] = "fob :"
  @@form_labels[:taxe_coefficient] = "Coef Taxe (%) :"

  def after_destroy
    self.counter_update(1)
  end
  
  # This method permit to actualize counter_cache if a commodity is disable
  def counter_update(value = -1)
    parent = CommodityCategory.find(self.commodity_category_id)
    CommodityCategory.update_counters(parent.id, :commodities_count => value)
  end
  
  # Check if a resource should be destroy or disable
  def can_be_destroyed?
    #TODO code the method can_be_destroyed? for commodity
    false
  end
  
end
