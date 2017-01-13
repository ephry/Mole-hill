
# Math modules were a warm up as we started the learn elixir process
# The recursive problem was one we saw 30 Years ago in CS 101
# Not sure we would ever implement transforms recursively in a tool
# Unit tests for Time Transform




defmodule Powers do

  def exp( pow, num) when pow  < 1  do 
     1 
  end

  def exp(pow, num) do
    # X= “Running”
     #IO.puts  X 
     num=  num * exp(pow - 1 , num )
  end

end



defmodule Recursion do
  def print_multiple_times(msg, n) when n <= 1 do
    IO.puts msg
  end

  def print_multiple_times(msg, n) do
    IO.puts msg
    print_multiple_times(msg, n - 1)
  end
end


defmodule Math do
  def sum(a, b) do
    a + b
  end
end


# The Weather Data file we have as our source supplies timestamp data in the format below
#


# Time Transform
# http://michal.muskala.eu/2015/07/30/unix-timestamps-in-elixir.html 

defmodule Convert  do
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
end





IO.puts "Starting Initial Unit Tests"



# Function TESTS
IO.puts "of Two numbers 1 + 2 "

IO.puts Math.sum(1, 2)

IO.puts "Exponents 5 **2   2 ** 3.14 Which rounds to 8 (2 cubed) "

IO.puts (Powers.exp(2, 5))

IO.puts (Powers.exp(3.14, 2))

IO.puts " Convert a time Stamp 1394690400   into a Touple"

IO.inspect (Convert.from_timestamp(1394690400)    )


 







