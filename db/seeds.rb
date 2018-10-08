
user = User.new(username: 'kassisadmin', password: 'kassispassword')
user.save!

puts "db:seeds success"