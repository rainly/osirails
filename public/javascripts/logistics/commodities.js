/* This method permit to return selected option value for a select */
function selectedValue(select) {
    return select.options[select.selectedIndex].value;  
}

function disableUnitMeasure() {
  select = document.getElementById('commodity_category_commodity_category_id');

  value = selectedValue(select);
  
  if (value == "" ) {
  document.getElementById('commodity_category_unit_measure_id').disabled = true;
  }
  else {
  document.getElementById('commodity_category_unit_measure_id').disabled = false;
  }
}

function develop(parent){
  position = parent.id.lastIndexOf("_");
  id = parent.id.substr(position + 1);
  
  elements = document.getElementsByClassName(parent.id);
  
  for (i = 0; i < elements.length; i++)
  {            
    elements[i].style.display='table-row';      
  }
      
  for (i = 0; i < elements.length; i++) {
    elements_position = elements[i].id.lastIndexOf("_");
    elements_id = elements[i].id.substr(position + 1);
    
    if (elements_id != "") {
      actual_status = document.getElementById('commodity_category_'+elements_id+'_develop').style.display;
      elements_child = document.getElementsByClassName('commodity_category_'+elements_id)
      if (actual_status != "none") {
        for (j = 0; j < elements_child.length; j++) {
          elements_child[j].style.display='none';
        }
          
      }
    }
          
  }
      
  document.getElementById('commodity_category_'+id+'_develop').style.display='none';
  document.getElementById('commodity_category_'+id+'_reduce').style.display='inline';
}

function reduce(parent){
  position = parent.id.lastIndexOf("_");
  id = parent.id.substr(position + 1);

  elements = document.getElementsByClassName(parent.id);

  for (i = 0; i < elements.length; i++){
    elements[i].style.display='none';
  }

  document.getElementById('commodity_category_'+id+'_develop').style.display='inline';
  document.getElementById('commodity_category_'+id+'_reduce').style.display='none';
}

// This method permit to calculate commodity price
function price_calculator(element) {
  position = element.id.lastIndexOf("_");
  id = element.id.substr(position + 1);
  var fob_unit_price = document.getElementById('commodity_'+id+'_fob_unit_price').innerHTML;
  var taxe_coefficient = document.getElementById('commodity_'+id+'_taxe_coefficient').innerHTML;
  price = (parseFloat(fob_unit_price) + (parseFloat(fob_unit_price) * parseFloat(taxe_coefficient))/100);
  document.getElementById('commodity_'+id+'_price').innerHTML = price;
}

// This function permits to refresh total value for categories
function total(parent) {
  // Find sub_category's id
  var reg = new RegExp("[ _ ]+", "g");
  var class_name = parent.className.split(reg);
  var sub_category_id = class_name[2];

  // Find category's id'
  var position = parent.className.lastIndexOf("_");
  var category_id = parent.className.substr(position + 1);

  // Select All ElementByClassName
  var sub_categories = document.getElementsByClassName('sub_commodity_category_'+sub_category_id+'_total');
  var categories = document.getElementsByClassName('commodity_category_'+category_id+'_total');
  var globals = document.getElementsByClassName('total');

  // Initialize totals
  var sub_category_total = 0;
  var category_total = 0;
  var global_total = 0;

  // Calcul sub_category_total
  for (i = 1; i < sub_categories.length ; i++){
    sub_category_total += parseFloat(sub_categories[i].innerHTML);
  }
    
  // Calcul category_total
  for (i = 1; i < categories.length ; i ++){
    category_total += parseFloat(categories[i].innerHTML);
  }
    
  // Calcul inventory_total
  for (i = 1; i < globals.length; i++){
    global_total += parseFloat(globals[i].innerHTML);
  }
    
  // Change total  
  sub_categories[0].innerHTML = sub_category_total;
  categories[0].innerHTML = category_total;
  globals[0].innerHTML = global_total;
  document.getElementById('total_ttc').innerHTML = global_total * 2;
}
