module Inplace
  module InstanceMethods
    # element_type
    #   * i.e. :span or :div
    #  
    # object
    #   * the object to edit (i.e. @artist)
    #   
    # property
    #   * the property to edit (i.e. name or description)
    # 
    # url
    #   * can be nil then route for this object will be used. The format ".json" is appended in any cases.
    #  
    # element_options
    #   * __id__ (DOM ID), default ID is generated if not given
    #   * other attributes for the element (i.e. style)
    #
    # edit_options
    #   * see Ajax.InPlaceEdit (zb okText, ....)
    #
    # ajax_options
    #   * __method__ is always set to **put**
    def editable_content_tag(element_type , object, property, editable = false, url = nil, element_options = {}, edit_options = {}, ajax_options = {})
      object_name = object.class.to_s.tableize.singularize
      element_options ||= {}
      element_options[:id] = dom_id(object)+"_#{property}" if element_options[:id].blank?()

      url ||= "/#{object_name.pluralize}/#{object.id}"
      url += '.json'

      ajax_options[:method] = 'put'
      options_for_edit = jsonify(edit_options)
      options_for_ajax = jsonify(ajax_options)

      tg = content_tag(element_type, object.send(property), element_options)

      if editable then
        put_params = protect_against_forgery? ?  "&authenticity_token=#{form_authenticity_token}" : ''
        tg += "
              <script type='text/javascript'>\n
                 new Ajax.InPlaceEditor(
                          '#{element_options[:id]}',
                          '#{url}', 
                          { 
                            ajaxOptions:  {#{options_for_ajax}},
                            callback: function(form, value)
                              { return '#{object_name}[#{property}]=' + value+ '#{put_params}' }, // hacked by Pentoo
                            onComplete: function(transport, element)
                              {
                                if(!transport) {return;} // thanks to Mina!
                                if(transport.status == 200) {
                                  new Effect.Highlight(element.id, {startcolor: '#00ffff'});
                                } else {
                                  new Effect.Highlight(element.id, {startcolor: '#ff0000'});
                                }
				element.innerHTML=transport.responseText.evalJSON().#{object.class.name.demodulize.tableize.singularize}.#{property};
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// hacked by Pentoo
                              if( element.id.substring(12,15) == 'inv' ) {
                                  totals_calculator(element.ancestors()[1]);
                               }
                               else {
                                 price_calculator(element.ancestors()[1]);
sub_total(element.ancestors()[1]);
                                }
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                              }"
        tg += ",#{options_for_edit}" unless options_for_edit.empty?
        tg += "});\n"
        tg += "         </script>\n"
      end
    end
    
    private
    # Encode a hash into the json format.
    def jsonify(hash)
      str = ''
      first = true
      hash.each do |k,v|
        str += ', ' unless first
        str += "#{k}: "
        str += "'" unless (v.class == Fixnum or v.class == Float)
        str += v.to_s
        str += "'" unless (v.class == Fixnum or v.class == Float)
        first = false
      end
      str
    end
  end
end