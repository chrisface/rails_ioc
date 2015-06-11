class OrderRepository

  def find(id)
    puts "I'm looking for the Order in the database which is slow and requires test data"
    return Order.new
  end

end
