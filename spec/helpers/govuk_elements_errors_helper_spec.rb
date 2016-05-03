require 'rails_helper'

RSpec.describe GovukElementsErrorsHelper, type: :helper do
  include TranslationHelper

  let(:resource)  { Person.new }
  let(:error_summary_heading) { 'Message to alert the user to a problem goes here' }
  let(:error_summary_description) { 'Optional description of the errors and how to correct them' }

  def split_html output
    output.split('>').join(">\n")
  end

  def expected_html message, attribute
    '<div ' +
        'class="error-summary" role="group" aria-labelledby="error-summary-heading" tabindex="-1">' +
      '<h1 id="error-summary-heading" class="heading-medium error-summary-heading">' +
        error_summary_heading +
      '</h1>' +
      '<p>' +
        error_summary_description +
      '</p>' +
      '<ul class="error-summary-list">' +
        %'<li><a href="#error_#{attribute}">#{message}</a></li>' +
      '</ul>' +
    '</div>'
  end

  shared_examples_for 'error summary' do |message, attribute|
    it 'outputs error full messages' do
      expect(output).to_not be_nil
      expected = expected_html message, attribute
      expect(split_html(output)).to eq split_html(expected)
    end
  end

  shared_examples_for 'error summary with translations' do |message, attribute, translations|
    it 'outputs error full messages' do
      with_translations(:en, translations) do
        expect(output).to_not be_nil
        expected = expected_html message, attribute
        expect(split_html(output)).to eq split_html(expected)
      end
    end
  end

  describe '#error_summary when object has validation errors' do
    let(:output) do
      resource.valid?
      described_class.error_summary resource, error_summary_heading, error_summary_description
    end

    include_examples 'error summary', 'Full name is required', 'person_name'

    include_examples 'error summary with translations', 'Enter your full name', 'person_name', YAML.load(%'
        errors:
          format: "%{message}"
        activemodel:
          errors:
            models:
              person:
                attributes:
                  name:
                    blank: "Enter your full name"
      ')
  end

  describe '#error_summary when child object has validation errors' do
    let(:output) do
      resource.address = Address.new
      resource.address.valid?

      described_class.error_summary resource, error_summary_heading, error_summary_description
    end

    include_examples 'error summary', 'Postcode is required', 'person_address_attributes_postcode'
  end

  describe '#error_summary when twice nested child object has validation errors' do
    let(:output) do
      resource.address = Address.new
      resource.address.country = Country.new
      resource.address.country.valid?

      described_class.error_summary resource, error_summary_heading, error_summary_description
    end

    include_examples 'error summary', 'Country is required', 'person_address_attributes_country_attributes_name'
  end

  describe '#error_summary when object does not have validation errors' do
    it 'outputs nil' do
      output = described_class.error_summary resource, error_summary_heading, error_summary_description
      expect(output).to eq nil
    end
  end

end
