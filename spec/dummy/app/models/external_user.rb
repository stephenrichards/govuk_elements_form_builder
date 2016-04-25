class ExternalUser
  include ActiveModel::Model

  attr_accessor :person

  def person_attributes=(attributes)
    @person = Person.new(attributes)
  end

end