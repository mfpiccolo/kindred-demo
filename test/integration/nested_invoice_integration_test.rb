require "test_helper"

describe "Nested Invoice Kindred Integration", type: :feature, js: true do

  before do
    @invoice = Invoice.create
  end

  it "New Box Line Item" do
    visit "/nested_invoices/#{@invoice.id}/edit"
    click_link "+ New Box"
    click_link "New Box Line Item"
    click_link "Save All"
    sleep 0.1
    page.evaluate_script('jQuery.active == 0').must_equal true
    page.all(".error").count.must_equal(1)
    all('input').each { |i| i.set("1") }
    BoxLineItem.count.must_equal 0
    click_link 'Save All'
    sleep 0.1
    page.evaluate_script('jQuery.active == 0').must_equal true
    page.all(".error").count.must_equal(0)
    BoxLineItem.count.must_equal 1
  end
end
