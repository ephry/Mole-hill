#################################################################################################
#
#
# The meat of this reader side came from this forum
# https://forums.pragprog.com/forums/322/topics/11945
#
#
# The purpose of the project was to take some weather data and transform it and possibly aggregate it.
# If we had had Mix working right away probably should have done the following
#
#  Mix/postgrex functions for time calculations Database tests
#  Yamal for a configuration file vs hard coding function order
#
#  Todos:
#  Debug thoroughly
#  Test the timestamp format convert against Data Start and End time
#  Create and test a lookup for missing data Business rules
#  Create an out file writer with different configureable formats jason, cvs ,etc
#  Create aggregation functions
#  Test larger files with and control thread with mix.
#  Create Kelvin conversion function
#
#
#  Csv data Samples provided http://bulk.openweathermap.org/sample/
################################################################################################


defmodule Writer do

  def save_results(data) do
    {:ok, file} = File.open "data.log", [:append]
    Enum.each(data, &(IO.binwrite(file, &1)))
    File.close file
  end

end






defmodule Reader do

# The meat of this side came from this forum
# https://forums.pragprog.com/forums/322/topics/11945



  def proccess_lines() do
    
  read_file("smallfile.csv")

 #    |> Perform_various_transformations(  )

 #   |> Enum.each(&IO.inspect/1)  # 
  end
  
  def read_file(filename) do
    stream = File.stream!(filename, [:read])
    
    columns = stream
    |> Enum.take(1)
    |> List.first
    |> String.split(",")
    |> Enum.map(&String.strip/1)
    |> Enum.map(&String.to_atom/1)
    |> Enum.each(&IO.inspect/1)      # At this point we are reading in the data ok
    stream
     |> Stream.drop(1)						    
   |> Stream.map(&convert_to_keyword_list(&1, columns))
    |> Stream.map(&convert_id/1)
     #|> Enum.each(&IO.inspect/1)
    |> Stream.map(&convert_city_name/1)
    
  

  end



  def convert_to_keyword_list(line, columns) do
    strings = line
      |> String.split(",")
      |> Enum.map(&String.strip/1)
      |> Enum.each(&IO.inspect/1)
    Enum.zip(columns, strings)
  end

  defp convert_id(row) do
    {i, ""} = row
    |> Keyword.get(:id)
    |> Integer.parse()
    Keyword.put(row, :id, i)
  end

  defp convert_city_name(row) do
    city_name = row
    |> Keyword.get(:city_name)
    |> String.replace(~r/^:/, "")
    |> String.to_atom
    Keyword.put(row, :city_name, city_name)
  end


# http://michal.muskala.eu/2015/07/30/unix-timestamps-in-elixir.html 
# Tested this externally However Integration not complete here
# Data File in this format tested in math.exs file



  epoch = {{1970, 1, 1}, {0, 0, 0}}
  @epoch :calendar.datetime_to_gregorian_seconds(epoch)

  def from_timestamp(timestamp) do
    timestamp
    |> +(@epoch)
    |> :calendar.gregorian_seconds_to_datetime
    
  end

  def to_timestamp(datetime) do
    datetime
    |> :calendar.datetime_to_gregorian_seconds
    |> -(@epoch)
  end


  defp convert_Start_time(row) do
    {i, ""} = row
    |> Keyword.get(:Start_Time)
    |> from_timestamp()
    Keyword.put(row, :Start_Time, i)
  end

##
end





IO.puts "Starting Reader/Writer Processes"


Reader.proccess_lines 













