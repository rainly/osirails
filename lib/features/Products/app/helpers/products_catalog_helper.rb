module ProductsCatalogHelper
  
  # This method permit to return a collection for all categories.
  def column(categories,value)
    if value == 0
      categories.each do |category|
        category.name += " (#{category.product_references_count})"
      end
      return  categories
    else value > 0
      child = []
      categories.each do |category|
        child << category.child_ids
      end
      value -= 1
      column(ProductReferenceCategory.find(child),value)
    end
  end
  
  # This method permit to know how much categories's column.
  def find_max_level
    categories = ProductReferenceCategory.find(:all)
    max_level = 0
    categories.each do |category|
      if category.ancestors.size > max_level
        max_level = category.ancestors.size
      end      
    end
    max_level
  end
  
  # This method permit to get a structure of catalog
  def show_category_column(categories,value)
    get_categories_columns = []
      collection = column(categories,value)
      selected = collection.collect { |t| t.id.to_s }
      get_categories_columns << "<select name='select_#{value}' id='select_#{value}' size=\"10\" multiple=\"multiple\" style=\"width:160px;\"><option value=\"-1\" selected=\"selected\">Il y a "+
        pluralize(collection.size, "categorie", "categories")+"</option>"+
        options_from_collection_for_select(collection, :id, :name, selected)+"</select>"
    get_categories_columns
  end
  
  # This method permit to have a reference column
  def show_reference_column(references)
    references.each do |reference|
      reference.name += " (#{reference.products_count})"
    end
    get_reference_column = []
    selected = references.collect { |t| t.id.to_s }
    get_reference_column << "<select id=\"select_reference\" size=\"10\" multiple=\"multiple\" style=\"width:160px;\" ><option value=\"-1\" selected=\"selected\">Il y a "+
      pluralize(references.size, "reference", "references")+"</option>"+
      options_from_collection_for_select(references, :id, :name, selected)+"</select>"
    get_reference_column
  end
    
end