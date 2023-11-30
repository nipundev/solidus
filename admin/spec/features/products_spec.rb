# frozen_string_literal: true

require 'spec_helper'

describe "Products", type: :feature do
  before { sign_in create(:admin_user, email: 'admin@example.com') }

  it "lists products", :js do
    create(:product, name: "Just a product", slug: 'just-a-prod', price: 19.99)

    visit "/admin/products"

    expect(page).to have_content("Just a product")
    expect(page).to have_content("$19.99")
    expect(page).to be_axe_clean

    find('table tbody tr', text: 'Just a product').click

    expect(page).to have_current_path("/admin/products/just-a-prod")
    expect(page).to have_content("Manage images")
  end

  it "can delete multiple products at once", js: true do
    create(:product, name: "Just a product", price: 19.99)
    create(:product, name: "Another product", price: 29.99)

    visit "/admin/products"
    select_row("Just a product")
    click_button "Delete"

    expect(page).to have_content("Products were successfully removed.", wait: 5)
    expect(page).not_to have_content("Just a product")
    expect(page).to have_content("Another product")
    expect(Spree::Product.count).to eq(1)
    expect(page).to be_axe_clean
  end

  it "can discontinue and (re)activate multiple products at once", js: true do
    create(:product, name: "Just a product", price: 19.99)
    create(:product, name: "Another product", price: 29.99)

    visit "/admin/products"
    find('main tbody tr:nth-child(2)').find('input').check
    click_button "Discontinue"

    expect(page).to have_content("Products were successfully discontinued.", wait: 5)
    within('main tbody tr:nth-child(2)') {
      expect(page).to have_content("Just a product")
      expect(page).to have_content("Discontinued")
      expect(page).not_to have_content("Available")
    }
    within('main tbody tr:nth-child(1)') {
      expect(page).to have_content("Another product")
      expect(page).not_to have_content("Discontinued")
      expect(page).to have_content("Available")
    }

    find('main tbody tr:nth-child(2)').find('input').check
    click_button "Activate"

    expect(page).to have_content("Products were successfully activated.", wait: 5)
    expect(page).to have_content("Just a product")
    expect(page).to have_content("Another product")
    expect(page).not_to have_content("Discontinued")
    expect(page).to have_content("Available").twice
    expect(page).to be_axe_clean
  end
end
