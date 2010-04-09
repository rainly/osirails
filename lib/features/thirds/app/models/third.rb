class Third < ActiveRecord::Base
  belongs_to :legal_form
  
  validates_presence_of :name, :legal_form_id
  validates_presence_of :legal_form, :if => :legal_form_id
 
  
  validates_format_of :website, :with         => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix,
                                :allow_blank  => true,
                                :message      => "L'adresse du site web ne respecte pas le format demandé"
  
  RATINGS = { "0" => 0, "1" => 1, "2" => 2, "3" => 3, "4" => 4, "5" => 5 }
  
  cattr_reader :form_labels
  @@form_labels = Hash.new
  @@form_labels[:name]            = "Raison Sociale :"
  @@form_labels[:legal_form]      = "Forme juridique :"
  @@form_labels[:siret_number]    = "Numéro SIRET :"
  @@form_labels[:activity_sector_reference] = "Code NAF :"
  @@form_labels[:website]         = "Site Internet :"
  @@form_labels[:note]            = "Note :"
end
