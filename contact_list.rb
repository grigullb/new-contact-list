require_relative 'contact'


class ContactList

  def intialize
	  
	end

  class << self
	  def print_menu
	  	puts "Here is a list of avaliable commands:"
	  	puts "	new     - Create a new contact"
	  	puts "	list    - list all contacts"
	  	puts "	show    - show a contact"
	  	puts "	search  - search a contacts" 
	  end

	  def list
	  	contact_list=Contact.all
	  	contact_list.each do |contact|
	  		puts "#{contact['id']}: #{contact['name']} (#{contact['email']})"
	  	end
	  	puts "#{contact_list.cmd_tuples} records found"
	  end

	  def new_contact
	  	print "Name of contact: "
	  	name = STDIN.gets.chomp
	  	print "Email Address: "
	  	email= STDIN.gets.chomp
	  	Contact.create(name, email)
		end

		def search_index(id)
			found = Contact.find(id)
	  	puts "#{found.id}: #{found.name} (#{found.email})"
		end

		def search
			print "search: " 
			search = STDIN.gets.chomp
			found =  Contact.search(search)
			found.each do |contact|
	  		puts "#{contact.id}: #{contact.name} (#{contact.email})"
	  	end
		end

		def update(id)
			contact = Contact.find(id)
			puts contact.inspect
			print "Name of contact: "
	  	new_name = STDIN.gets.chomp
	  	contact.name = new_name
	  	print "Email Address: "
	  	new_email= STDIN.gets.chomp
	  	contact.save
		end

		def destroy(id)
			contact = Contact.find(id)
			contact.destroy
		end

end

end
	

	puts ARGV
	command = ARGV[0]
	index = ARGV[1]

  if !command
  	ContactList.print_menu
  elsif command == 'list'
  	ContactList.list
  elsif command == 'new'
  	ContactList.new_contact
	elsif command == 'show'
		 ContactList.search_index(index)
	elsif command == 'search'
		ContactList.search
	elsif command == 'update'
		ContactList.update(index)
	elsif command == 'destroy'
		ContactList.destroy(index)
  end
