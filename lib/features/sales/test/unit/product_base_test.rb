module ProductBaseTest
  
  class << self
    def included base
      base.class_eval do
        
        context "A valid and saved quote_item" do
          setup do
            @order = create_default_order
            @quote = create_quote_for(@order)
            @quote_item = @quote.quote_items.first
          end
          
          teardown do
            @order = @quote = @quote_item = nil
          end
          
          should "have a 'unit_price_with_prizegiving' value equal to '0' when unit_price is nil" do
            @quote_item.unit_price = nil
            assert_equal 0, @quote_item.unit_price_with_prizegiving
          end
          
          [nil, 0].each do |prizegiving|
            should "have a correct 'unit_price_with_prizegiving' value when prizegiving is equal to '#{prizegiving}'" do
              @quote_item.prizegiving = prizegiving
              expected_value = @quote_item.unit_price
              
              assert_equal expected_value, @quote_item.unit_price_with_prizegiving
            end
          end
          
          [1, 8.0, 15.5, 30.79].each do |prizegiving|
            should "have a correct 'unit_price_with_prizegiving' value when prizegiving is equal to '#{prizegiving}'" do
              prizegiving = BigDecimal.new(prizegiving.to_s)
              @quote_item.prizegiving = prizegiving
              expected_value = BigDecimal.new(@quote_item.unit_price.to_s) / ( 1 + ( prizegiving / 100 ) )
              
              assert_equal expected_value, @quote_item.unit_price_with_prizegiving
            end
          end
          
          should "have a 'total' value equal to '0' when quantity is nil" do
            @quote_item.quantity = nil
            assert_equal 0, @quote_item.total
          end
          
          [1, 8.0, 15.5, 30.79].each do |quantity|
            should "have a correct 'total' value when quantity is equal to '#{quantity}'" do
              @quote_item.quantity = quantity
              expected_value = @quote_item.unit_price_with_prizegiving * quantity
              assert_equal expected_value, @quote_item.total
            end
          end
          
          [nil, 0, 0.0].each do |vat|
            should "have a 'total_with_taxes' value equal to 'total' when vat is equal to '#{vat}'" do
              @quote_item.vat = vat
              assert_equal @quote_item.total, @quote_item.total_with_taxes
            end
          end
          
          [1, 8.0, 15.5, 30.79].each do |vat|
            should "have a correct 'total_with_taxes' value when vat is equal to '#{vat}'" do
              @quote_item.vat = vat
              expected_value = @quote_item.total + (@quote_item.total * ( vat.to_f / 100 ))
              assert_equal expected_value, @quote_item.total_with_taxes
            end
          end
        end
        
      end
    end
  end
  
end
