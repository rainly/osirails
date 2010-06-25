module PurchaseOrderSuppliesHelper
  def display_purchase_order_buttons(purchase_order_supply)
    html = []
    html << display_purchase_order_supply_show_button(purchase_order_supply, '')
    html << display_purchase_order_supply_delete_button(purchase_order_supply, '')
    html << display_purchase_order_supply_cancel_button(purchase_order_supply, '')
    html.compact.join("&nbsp;")
  end
  
  def display_purchase_order_supply_show_button(purchase_order_supply, message = nil)
    return unless PurchaseOrderSupply.can_view?(current_user) and !purchase_order_supply.new_record?
    text = "Voir les détails de cette fourniture"
    message ||= " #{text}"
    link_to( image_tag( "view_16x16.png",
                        :alt => text,
                        :title => text ) + message,
             purchase_order_supply_path(purchase_order_supply) )
  end
  
  def display_purchase_order_supply_delete_button(purchase_order_supply, message = nil)
    return unless PurchaseOrderSupply.can_delete?(current_user) and purchase_order_supply.can_be_deleted? and (purchase_order_supply.purchase_order.purchase_order_supplies.count > 1)
    text = "Supprimer cette fourniture"
    message ||= " #{text}"
    link_to( image_tag( "delete_16x16.png",
                        :alt => text,
                        :title => text ) + message,
             purchase_order_supplies_path, :method => :delete, :confirm => "Êtes vous sûr?")
  end
  
  def display_purchase_order_supply_cancel_button(purchase_order_supply, message = nil)
    return unless PurchaseOrderSupply.can_cancel?(current_user) and purchase_order_supply.can_be_cancelled?
    text = "Annuler cette fourniture"
    message ||= " #{text}"
    link_to( image_tag( "cancel_16x16.png",
                        :alt    => text,
                        :title  => text ) + message,
             purchase_order_supply_cancel_path(purchase_order_supply),
             :confirm => "Êtes-vous sûr ?" )
  end
  
  def display_purchase_order_supply_reference(purchase_order_supply)
    return "Aucune" unless purchase_order_supply.supply.reference
    purchase_order_supply.supply.reference
  end
  
  def display_unit_price_including_tax(purchase_order_supply, supplier_supply)
    unit_price = purchase_order_supply.get_unit_price_including_tax
    unit_price.to_f.to_s(2) + "&nbsp;&euro;"
  end
  
  def display_purchase_order_total(purchase_order_supply)
    (purchase_order_supply.quantity.to_f * purchase_order_supply.get_unit_price_including_tax).to_f.to_s(2) +"&nbsp;&euro;"
  end
  
  def display_purchase_order_supply_status(purchase_order_supply)
    case purchase_order_supply.status
      when PurchaseOrderSupply::STATUS_UNTREATED
        "Non traité"
      when PurchaseOrderSupply::STATUS_PROCESSING
        "En traitement"
      when PurchaseOrderSupply::STATUS_SENT_BACK
        "Renvoyé au fournisseur"
      when PurchaseOrderSupply::STATUS_RESHIPPED
        "Retourné par le fournisseur"
      when PurchaseOrderSupply::STATUS_REIMBURSED
        "Remboursé"
      when PurchaseOrderSupply::STATUS_CANCELLED
        "Annulé"
      else
        "Impossible d'afficher le statut correspondant pour la commande"
    end
  end
  
  def display_purchase_order_supply_current_status_date(purchase_order_supply)
    case purchase_order_supply.status
      when PurchaseOrderSupply::STATUS_UNTREATED
        purchase_order_supply.created_at ? purchase_order_supply.created_at.humanize : "Aucune date de création"
      when PurchaseOrderSupply::STATUS_PROCESSING
        purchase_order_supply.processing_since ? purchase_order_supply.processing_since.humanize : "Aucune date de début de traitement"
      when PurchaseOrderSupply::STATUS_SENT_BACK
        purchase_order_supply.sent_back_at ? purchase_order_supply.sent_back_at.humanize : "Aucune date de renvoi au fournisseur"
      when PurchaseOrderSupply::STATUS_RESHIPPED
        purchase_order_supply.reshipped_at ? purchase_order_supply.reshipped_at.humanize : "Aucune date de recolissage du fournisseur"
      when PurchaseOrderSupply::STATUS_REIMBURSED
        purchase_order_supply.reimbursed_at ? purchase_order_supply.reimbursed_at.humanize : "Aucune date de remboursement"
      when PurchaseOrderSupply::STATUS_CANCELLED
        purchase_order_supply.cancelled_at ? purchase_order_supply.cancelled_at.humanize : "Aucune date d'annulation"
      else
        "Impossible de trouver le statut correspondant pour la commande"
    end
  end
  
  def display_purchase_order_supply_associated_purchase_requests(purchase_order_supply)
    html = []
    associated_purchase_requests = purchase_order.get_associated_purchase_requests
    return "Aucune demande associée" if associated_purchase_requests.empty?
    for purchase_request in associated_purchase_requests
      html << link_to(purchase_request.reference, purchase_request_path(purchase_request))
    end
    html.compact.join("<br />")
  end
  
    
  def display_purchase_order_supply_parcel_reference(purchase_order_supply)
    return "Aucun" unless purchase_order_supply.parcel
    link_to( purchase_order_supply.parcel.reference, parcel_path(purchase_order_supply.parcel))
  end
  
  def display_purchase_order_supply_supplier_designation(purchase_order_supply)
    return purchase_order_supply.supplier_designation if purchase_order_supply.supplier_designation
    purchase_order_supply.get_supplier_supply.supplier_designation
  end
  
  def display_purchase_order_supply_supplier_reference(purchase_order_supply)
    return "Aucune" unless purchase_order_supply.supplier_reference or purchase_order_supply.get_supplier_supply.supplier_reference
    purchase_order_supply.supplier_reference or purchase_order_supply.get_supplier_supply.supplier_reference
  end
  
  def display_purchase_order_lead_time(purchase_order_supply)
    lead_time = purchase_order_supply.get_supplier_supply.lead_time
    if !lead_time
      "Non renseigné"
    elsif lead_time == 0
      "Immédiat"
    else
      lead_time.to_s + "&nbsp;jour(s)"
    end
  end
end
