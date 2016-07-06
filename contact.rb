
require 'csv'
require 'pry'
require 'pg'

class Contact

  attr_accessor :name, :email, :id, :saved
  
  def initialize(name, email)
    @name = name
    @email = email
    @id = nil
    @saved = false
  end

  def set_id
    conn = Contact.connection
    res = conn.exec_params("SELECT id FROM contacts WHERE name LIKE '#{@name}'")
    self.id = res[0]['id']
  end

  def same_email?(email)
    check = Contact.search(email)
    if check.any?
      true
    else
      false
    end
  end

  def save
    conn = Contact.connection
    if self.saved
      conn.exec_params("UPDATE contacts SET name = $1, email = $2 WHERE id = $3::int", [self.name, self.email, self.id])
    else
      conn.exec_params("INSERT INTO contacts (name, email) VALUES ($1,$2)", [self.name, self.email])
      @saved = true
    end
  end

  def destroy
    conn = Contact.connection
    conn.exec_params("DELETE FROM contacts WHERE id = $1::int", [self.id])
  end

  class << self

    def connection
      conn = PG.connect(
      host: 'localhost',
      dbname: 'contact_list',
      user: 'development',
      password: 'development'
      )
    end

    def all
      conn = self.connection
      res = conn.exec_params('SELECT * FROM contacts')
    end

    def create(name,email)
      contact = Contact.new(name, email)
      if contact.same_email?(email)
        puts "A contact already has that email address"
      else
        contact.save
      end
    end
    
    def find(id)
      conn = self.connection
      res = conn.exec_params("SELECT * FROM contacts WHERE id = $1::int", [id])
      contact = Contact.new(res[0]['name'], res[0]['email'])
      contact.set_id
      contact.saved = true
      contact
    end
    
    def search(term)
      found = []
      conn = self.connection
      res = conn.exec_params("SELECT id, name, email FROM contacts WHERE name LIKE '%#{term}%' OR email LIKE '%#{term}%'"). each do |row|
        contact = Contact.new(row['name'], row['email'])
        contact.set_id
        found << contact
      end
      found
    end
  end
end




