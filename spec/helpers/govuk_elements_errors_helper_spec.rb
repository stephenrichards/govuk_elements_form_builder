require 'rails_helper'

RSpec.describe GovukElementsErrorsHelper, type: :helper do

  let(:resource)  { Person.new }
  let(:error_summary_heading) { 'Message to alert the user to a problem goes here' }
  let(:error_summary_description) { 'Optional description of the errors and how to correct them' }

  describe '#error_summary when object has validation errors' do
    it 'outputs error full messages' do
      resource.valid?
      output = described_class.error_summary resource, error_summary_heading, error_summary_description
      expect(output.split('>').join(">\n")).to eq ('<div ' +
          'class="error-summary" role="group" aria-labelledby="error-summary-heading" tabindex="-1">' +
        '<h1 id="error-summary-heading" class="heading-medium error-summary-heading">' +
          error_summary_heading +
        '</h1>' +
        '<p>' +
          error_summary_description +
        '</p>' +
        '<ul class="error-summary-list">' +
          '<li><a href="#error_person_name">Name can&#39;t be blank</a></li>' +
        '</ul>' +
      '</div>').split('>').join(">\n")
    end
  end

  describe '#error_summary when object does not have validation errors' do
    it 'outputs nil' do
      output = described_class.error_summary resource, error_summary_heading, error_summary_description
      expect(output).to eq nil
    end
  end

end
