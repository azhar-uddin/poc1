# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
admin = User.new
admin.first_name = 'admin'
admin.last_name = 'admin'
admin.email = 'admin@interns.com'
admin.password = 'qwerty'
admin.mobile = '9876543210'
admin.role = 2
admin.email_confirmed = true
admin.confirm_token = 'NULL'
admin.save!