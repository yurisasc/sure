require "test_helper"

class PagesMissingReportingFxTest < ActionDispatch::IntegrationTest
  include EntriesTestHelper

  test "dashboard warns for missing reporting rates only for eligible accessible entries" do
    user = users(:family_member)
    sign_in user

    create_transaction(account: accounts(:depository), currency: "CAD")
    create_transaction(account: accounts(:other_asset), currency: "CHF")

    get root_path

    assert_response :ok
    assert_select "[class*='bg-warning']", text: /CAD/
    assert_select "[class*='bg-warning']", text: /CHF/, count: 0

    ExchangeRate.create!(from_currency: "CAD", to_currency: user.family.currency, date: 30.days.ago.to_date, rate: 0.75)
    get root_path

    assert_response :ok
    assert_select "[class*='bg-warning']", text: /CAD/, count: 0
  end
end
