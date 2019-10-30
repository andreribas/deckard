defmodule Scrum2000.Utils do

  def is_iso8601_date_between_iso8601_dates?(date, start_date, end_date) do
    date = date_from_iso8601_datetime(date)
    start_date = Date.from_iso8601!(start_date)
    end_date = Date.from_iso8601!(end_date)

    is_date_after_start_date = (Date.compare(date, start_date) !== :lt)
    is_date_before_end_date = (Date.compare(date, end_date) !== :gt)

    is_date_after_start_date and is_date_before_end_date
  end

  def date_from_iso8601_datetime(datetime) do
    {:ok, datetime, 0} = DateTime.from_iso8601(datetime)
    DateTime.to_date(datetime)
  end

end
