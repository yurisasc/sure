require "test_helper"

class ReportingExchangeRateTest < ActiveSupport::TestCase
  test "reporting prefers the latest prior rate over later rates and handles parity and absent pairs" do
    date = Date.current
    ExchangeRate.create!(from_currency: "IDR", to_currency: "AUD", date: date - 40, rate: 0.0001)
    ExchangeRate.create!(from_currency: "IDR", to_currency: "AUD", date: date - 30, rate: 0.0002)
    ExchangeRate.create!(from_currency: "IDR", to_currency: "AUD", date: date + 1, rate: 0.0003)

    assert_equal BigDecimal("0.0002"), reporting_rate("IDR", "AUD", date)
    assert_equal 1, reporting_rate("AUD", "AUD", date)
    assert_nil reporting_rate("KRW", "AUD", date)

    ExchangeRate.create!(from_currency: "IDR", to_currency: "AUD", date: date, rate: 0.0004)
    assert_equal BigDecimal("0.0004"), reporting_rate("IDR", "AUD", date)
  end

  private
    def reporting_rate(from, to, date)
      expression = ExchangeRate.rate_sql(from: ":from", to: ":to", on: ":date")
      sql = ActiveRecord::Base.sanitize_sql_array([ "SELECT #{expression}", { from: from, to: to, date: date } ])
      ActiveRecord::Base.connection.select_value(sql)
    end
end
