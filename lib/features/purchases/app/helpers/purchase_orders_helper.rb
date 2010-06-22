module PurchaseOrdersHelper

  def generate_purchase_order_contextual_menu_partial
    render :partial => 'purchase_orders/contextual_menu'
  end

  def display_purchase_order_add_button(message = nil)
    return unless PurchaseOrder.can_add?(current_user)
    text = "Nouvel ordre d'achats"
    message ||= " #{text}"
    link_to( image_tag( "add_16x16.png",
                        :alt => text,
                        :title => text ) + message,
             new_purchase_order_path(:choice => true))
  end
  
  def display_purchase_order_show_button(purchase_order, message = nil)
    return unless PurchaseOrder.can_view?(current_user) and !purchase_order.new_record?
    text = "Voir cet ordre d'achats"
    message ||= " #{text}"
    link_to( image_tag( "view_16x16.png",
                        :alt => text,
                        :title => text ) + message,
             purchase_order_path(purchase_order) )
  end

  def display_purchase_order_edit_button(purchase_order, message = nil)
    return unless PurchaseOrder.can_view?(current_user) and purchase_order.can_be_edited?
    text = "Modifier cet ordre d'achats"
    message ||= " #{text}"
    link_to( image_tag( "edit_16x16.png",
                        :alt => text,
                        :title => text ) + message,
             edit_purchase_order_path(purchase_order) )
  end
  
  def display_purchase_order_delete_button(purchase_order, message = nil)
    return unless PurchaseOrder.can_delete?(current_user) and purchase_order.can_be_deleted?
    text = "Supprimer cet ordre d'achats"
    message ||= " #{text}"
    link_to( image_tag( "delete_16x16.png",
                        :alt => text,
                        :title => text ) + message,
             purchase_orders_path, :method => :delete, :confirm => "Êtes vous sûr?")
  end

  def display_purchase_order_cancel_button(purchase_order, message = nil)
    return unless PurchaseOrder.can_cancel?(current_user) and purchase_order.can_be_cancelled?
    text = "Annuler cet ordre d'achats"
    message ||= " #{text}"
    link_to( image_tag( "cancel_16x16.png",
                        :alt    => text,
                        :title  => text ) + message,
             purchase_order_cancel_path(purchase_order),
             :confirm => "Êtes-vous sûr ?" )
  end
  
  def display_purchase_order_supplies_list(purchase_order)
    purchase_order_supplies = purchase_order.purchase_order_supplies
    html = "<div id=\"supplies\" class=\"resources\">"
    html << render (:partial => 'purchase_order_supplies/begin_table')
    html << render (:partial => 'purchase_order_supplies/purchase_order_supply_in_one_line', :collection => purchase_order_supplies, :locals => { :purchase_order => purchase_order })
    html << render (:partial => 'purchase_order_supplies/end_table', :locals => { :purchase_order => purchase_order })
    html << "</div>"
  end
  
  def display_PU_TTC(purchase_order_supply, supplier_supply)
    if purchase_order_supply.fob_unit_price && purchase_order_supply.taxes
      html = (purchase_order_supply.fob_unit_price.to_f * ((100 + purchase_order_supply.taxes.to_f) / 100)).to_s
    else
      html = (supplier_supply.fob_unit_price.to_f * ((100 + supplier_supply.taxes.to_f) / 100)).to_s
    end
  end
  
  def display_total(purchase_order_supply)
    html = purchase_order_supply.quantity.to_f * (purchase_order_supply.fob_unit_price.to_f * ((100 + purchase_order_supply.taxes.to_f) / 100))
  end
  
  def display_longest_lead_time_for_supplier(supplier)
    merged_purchase_request_supplies = supplier.merge_purchase_request_supplies
    longest_lead_time = 0
    for merged_purchase_request_supply in merged_purchase_request_supplies
      if( merged_purchase_request_supply.supply.supplier_supplies.first(:conditions => ['supplier_id = ?', supplier]).lead_time > longest_lead_time )
        longest_lead_time = merged_purchase_request_supply.supply.supplier_supplies.first(:conditions => ['supplier_id = ?', supplier]).lead_time
      end
    end
    "#{longest_lead_time}&nbsp;jour(s)</p>"
  end
  
  def display_purchase_request_supplies_total_for_supplier(supplier)
    merged_purchase_request_supplies = supplier.merge_purchase_request_supplies
    totals_sum = 0
    for merged_purchase_request_supply in merged_purchase_request_supplies
      merged_purchase_request_supply_supplier = merged_purchase_request_supply.supply.supplier_supplies.first( :conditions => ['supplier_id = ?', supplier])
      totals_sum += (merged_purchase_request_supply_supplier.fob_unit_price * ((100 + merged_purchase_request_supply_supplier.taxes ) / 100)) * merged_purchase_request_supply.expected_quantity
    end
    "<p style=\"text-align:right\">#{totals_sum.to_f.to_s(2)}&nbsp;&euro;</p>"
  end
  
  def display_choose_supplier_button(supplier)
    link_to (image_tag("next_24x24.png", :alt => "Choisir" + supplier.name), new_purchase_order_path(:supplier_id => supplier))
  end
  
  def display_purchase_order_status(purchase_order)
    case purchase_order.status
      when PurchaseOrder::STATUS_DRAFT
        'Brouillon'
      when PurchaseOrder::STATUS_CONFIRMED
        'Confirmé'
      when PurchaseOrder::STATUS_PROCESSING
        'En traitement'
      when PurchaseOrder::STATUS_COMPLETED
        'Complété'
      when PurchaseOrder::STATUS_CANCELLED
        'Annulé'
    end
  end
  
  def display_purchase_order_status_date(purchase_order)
    case purchase_order.status
      when PurchaseOrder::STATUS_DRAFT
        purchase_order.created_at.humanize
      when PurchaseOrder::STATUS_CONFIRMED
        purchase_order.confirmed_at.humanize
      when PurchaseOrder::STATUS_PROCESSING
        purchase_order.processing_since.humanize
      when PurchaseOrder::STATUS_COMPLETED
        purchase_order.completed_at.humanize
      when PurchaseOrder::STATUS_CANCELLED
        purchase_order.cancelled_at.humanize
    end
  end
  
  def display_parcel_status(parcel)
    case parcel.status
      when Parcel::STATUS_PROCESSING
        'En traitement'
      when Parcel::STATUS_SHIPPED
        'Envoyé'
      when Parcel::STATUS_RECEIVED
        'Reçu'
    end
  end
  
  def display_parcel_status_date(parcel)
    case parcel.status 
      when Parcel::STATUS_PROCESSING
        parcel.created_at.humanize
      when Parcel::STATUS_SHIPPED
        parcel.shipped_at.humanize
      when Parcel::STATUS_RECEIVED
        parcel.received_at.humanize
    end
  end
  
  def display_parcel_previsional_deliveray_date(parcel)
    return parcel.previsional_delivery_date.humanize unless parcel.previsional_delivery_date == nil
    "Non définie"
  end
  
  def display_associated_purchase_requests(purchase_order)
    html = []
    associated_purchase_requests = purchase_order.get_associated_purchase_requests
    return "Aucune demande associée" if associated_purchase_requests.empty?
    for purchase_request in associated_purchase_requests
      html << link_to(purchase_request.reference, purchase_request_path(purchase_request))
    end
    html.compact.join("<br />")
  end
  
  def display_total_price(purchase_order)
    purchase_order.total_price.to_f.to_s(2) + "&nbsp;€"
  end
  
  def display_paid(purchase_order)
    return image_tag( "cross_16x16.png", :alt => "Non payé", :title => "Non payé" ) unless purchase_order.paid
    image_tag( "tick_16x16.png", :alt => "Payé", :title => "Payé" )
  end
  
  def display_lead_time(purchase_order)
    return "Immédiat" unless purchase_order.lead_time
    purchase_order.lead_time.to_s + "&nbsp;jour(s)"
  end
  
  def display_purchase_order_buttons(purchase_order)
    html = []
    html << display_purchase_order_show_button(purchase_order, '')
    html << display_purchase_order_edit_button(purchase_order, '')
    html << display_purchase_order_delete_button(purchase_order, '')
    html << display_purchase_order_cancel_button(purchase_order, '')
    html.compact.join("&nbsp;")
  end
end
