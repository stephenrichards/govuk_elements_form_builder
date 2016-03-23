require 'rails_helper'
require 'spec_helper'

class TestHelper < ActionView::Base; end

RSpec.describe GovukElementsFormBuilder::FormBuilder do

  it "should have a version" do
    expect(GovukElementsFormBuilder::VERSION).to eq("0.0.1")
  end

  let(:helper) { TestHelper.new }
  let(:resource)  { Person.new }
  let(:builder) { described_class.new :person, resource, helper, {} }

  describe '#text_field' do
    it 'outputs correct markup' do
      output = builder.text_field :name
      expect(output).to eq '<div class="form-group">' +
        '<label class="form-label" for="person_name">Full name</label>' +
        '<input class="form-control" type="text" name="person[name]" id="person_name" />' +
        '</div>'
    end
  end


end
