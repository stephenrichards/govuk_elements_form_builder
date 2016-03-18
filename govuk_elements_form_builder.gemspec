$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "govuk_elements_form_builder/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "govuk_elements_form_builder"
  s.version     = GovukElementsFormBuilder::VERSION
  s.authors     = ["Alistair Laing"]
  s.email       = ["Alistair.Laing@Digital.Justice.gov.uk"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of GovukElementsFormBuilder."
  s.description = "TODO: Description of GovukElementsFormBuilder."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.5.1"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "guard-rspec"

  s.add_development_dependency "byebug"
end
