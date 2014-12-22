require "test_helper"

describe "Line Item Kindred Integration", type: :feature, js: true do

  before do
    @invoice = Invoice.create
  end
  # adds new line item fills out fields, saves and checks errors and dirty state allong the way
  it "New Line Item" do
    visit "/invoices/#{@invoice.id}/edit"
    page.must_have_content "INVOICE ##{@invoice.id}"
    click_link 'New Line Item'
    page.must_have_content "Save"
    find(".persist").click
    page.must_have_content "can't be blank"
    find("input[data-attr='description']").set("Some Description")
    page.all(".error").count.must_equal(3)
    find(".persist").click
    page.all(".error").count.must_equal(2)
    find("input[data-attr='qty']").set("12")
    find(".persist").click
    page.all(".error").count.must_equal(1)
    find("i")["class"].must_equal("fa fa-exclamation-triangle fa-2x")
    find("i")["style"].must_equal("color:#D24D57;")
    find("input[data-attr='price_cents']").set("12")
    find(".persist").click
    page.all(".error").count.must_equal(0)
    find("i")["class"].must_equal("fa fa-check-circle-o fa-2x")
    find("i")["style"].must_equal("color:#2ECC71;")
    find("input[data-attr='qty']").set("Not a number")
    find("i")["class"].must_equal("fa fa-exclamation-triangle fa-2x")
    find("i")["style"].must_equal("color:#F4D03F;")
    find("input[data-attr='description']").value.must_equal 'Some Description'
    find(".persist").click
    page.all(".error").count.must_equal(1)
    find("i")["style"].must_equal("color:#F4D03F;")
    find("input[data-attr='qty']").set("13")
    find(".persist").click
    page.all(".error").count.must_equal(0)
    find("i")["style"].must_equal("color:#2ECC71;")
  end

  describe "delete" do
    before do
      @line_item = FactoryGirl.create(:line_item, invoice_id: @invoice.id)
    end

    it "deletes the line item" do
      visit "/invoices/#{@invoice.id}/edit"
      @invoice.line_items.count.must_equal 1
      page.find("#line-item-table").must_have_content "Save"
      find(".delete").click
      @invoice.line_items.count.must_equal 0
      page.find("#line-item-table").wont_have_content "Save"
    end
  end

  describe "persist line item" do

    it "saves a line item" do
      visit "/invoices/#{@invoice.id}/edit"
      page.find("#line-item-table").wont_have_content "Save"
      click_link 'New Line Item'
      find("input[data-attr='description']").set("Some Description")
      find("input[data-attr='qty']").set("12")
      find("input[data-attr='price_cents']").set("13")
      find(".persist").click
      visit "/invoices/#{@invoice.id}/edit"
      page.find("#line-item-table").must_have_content "Save"
    end
  end

  describe "save_all" do
    describe "save all with already persisted line_items" do
      before do
        @uuid1 = "11111111-1111-1111-1111-11111111"
        @uuid2 = "22222222-2222-2222-2222-22222222"
        @invoice.line_items.create(qty: 1, description: "something1", price_cents: 2, uuid: @uuid1)
        @invoice.line_items.create(qty: 2, description: "something2", price_cents: 2, uuid: @uuid2)
      end

      it {
        visit "/invoices/#{@invoice.id}/edit"
        page.must_have_content "INVOICE ##{@invoice.id}"
        page.find("input[data-attr='description'][data-k-uuid='#{@uuid1}']").value.must_equal "something1"
        find("input[data-k-uuid='" + @uuid1 + "'][data-attr='qty']").set("not a number")
        click_link 'Save All'
        sleep 0.1
        page.all(".error").count.must_equal(1)
        find("input[data-k-uuid='" + @uuid1 + "'][data-attr='qty']").set "555"
        click_link 'Save All'
        sleep 0.1
        LineItem.find_by(uuid: @uuid1).qty.must_equal 555
        page.all(".error").count.must_equal(0)
      }
    end

    describe "save all with unpersisted line_items" do
      it {
        visit "/invoices/#{@invoice.id}/edit"
        page.must_have_content "INVOICE ##{@invoice.id}"
        click_link 'New Line Item'
        click_link 'New Line Item'
        click_link 'Save All'
        sleep 0.1
        page.evaluate_script('jQuery.active == 0').must_equal true
        page.all(".error").count.must_equal(6)
        all('input').each { |i| i.set("1") }
        click_link 'Save All'
        sleep 0.1
        page.evaluate_script('jQuery.active == 0').must_equal true
        page.all(".error").count.must_equal(0)
        LineItem.count.must_equal 2
      }
    end

    describe "save all with mixed persisted and unpersisted line_items" do
      before do
        @uuid1 = "11111111-1111-1111-1111-11111111"
        @invoice.line_items.create(qty: 1, description: "something1", price_cents: 2, uuid: @uuid1)
      end

      it {
        visit "/invoices/#{@invoice.id}/edit"
        page.must_have_content "INVOICE ##{@invoice.id}"
        click_link 'New Line Item'
        click_link 'Save All'
        sleep 0.1
        page.evaluate_script('jQuery.active == 0').must_equal true
        page.all(".error").count.must_equal(3)
        all('input').each { |i| i.set("1") }
        click_link 'Save All'
        sleep 0.1
        page.evaluate_script('jQuery.active == 0').must_equal true
        LineItem.find_by(uuid: @uuid1).qty.must_equal 1
        page.all(".error").count.must_equal(0)
      }
    end

  end
end
