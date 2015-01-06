require "test_helper"

describe "Nested Invoice Kindred Integration", type: :feature, js: true do

  before do
    @invoice = Invoice.create
  end

  it "New Box Line Item" do
    visit "/nested_invoices/#{@invoice.id}/edit"
    click_link "+ New Box"
    click_link "New Box Line Item"
    save_and_open_page
  end
end
