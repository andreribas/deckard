defmodule Deckard.UtilsTest do
  use ExUnit.Case

  alias Deckard.Utils

  test "is_iso8601_datetime_between_iso8601_dates" do
    assert true == Utils.is_iso8601_date_between_iso8601_dates?("2019-09-11T18:30:47Z", "2019-09-10", "2019-09-12")
    assert false == Utils.is_iso8601_date_between_iso8601_dates?("2019-09-10T18:30:47Z", "2019-09-11", "2019-09-12")
    assert false == Utils.is_iso8601_date_between_iso8601_dates?("2019-09-12T18:30:47Z", "2019-09-10", "2019-09-11")
  end

end
