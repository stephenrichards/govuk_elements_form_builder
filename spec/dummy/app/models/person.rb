class Person
  include ActiveModel::Model

  attr_accessor :name
  validates_presence_of :name

  attr_accessor :ni_number
  attr_accessor :email_work
  attr_accessor :email_home

end
