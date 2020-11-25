require "application_system_test_case"

class Api::V1::ContributionsTest < ApplicationSystemTestCase
  setup do
    @api_v1_contribution = api_v1_contributions(:one)
  end

  test "visiting the index" do
    visit api_v1_contributions_url
    assert_selector "h1", text: "Api/V1/Contributions"
  end

  test "creating a Contribution" do
    visit api_v1_contributions_url
    click_on "New Api/V1/Contribution"

    click_on "Create Contribution"

    assert_text "Contribution was successfully created"
    click_on "Back"
  end

  test "updating a Contribution" do
    visit api_v1_contributions_url
    click_on "Edit", match: :first

    click_on "Update Contribution"

    assert_text "Contribution was successfully updated"
    click_on "Back"
  end

  test "destroying a Contribution" do
    visit api_v1_contributions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Contribution was successfully destroyed"
  end
end
