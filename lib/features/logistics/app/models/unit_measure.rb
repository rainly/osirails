class UnitMeasure < ActiveRecord::Base
  validates_presence_of :name, :symbol
  
  validates_uniqueness_of :name, :symbol
  
  def symbol_and_name
    @symbol_and_name ||= "#{symbol} (#{name.downcase})"
  end
end
