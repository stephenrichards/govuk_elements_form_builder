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

  def expect_equal output, expected
    split_output = output.split("<").join("\n<").split(">").join(">\n").squeeze("\n").strip + '>'
    split_expected = expected.join("\n")
    expect(split_output).to eq split_expected
  end

  describe '#text_field' do
    it 'outputs label and input wrapped in div' do
      output = builder.text_field :name
      expect_equal output, [
        '<div class="form-group">',
        '<label class="form-label" for="person_name">',
        'Full name',
        '</label>',
        '<input class="form-control" type="text" name="person[name]" id="person_name" />',
        '</div>'
      ]
    end

    context 'when hint text provided' do
      it 'outputs hint text in span inside label' do
        output = builder.text_field :ni_number
        expect_equal output, [
          '<div class="form-group">',
          '<label class="form-label" for="person_ni_number">',
          'National Insurance number',
          '<span class="form-hint">',
          'It’ll be on your last payslip. For example, JH 21 90 0A.',
          '</span>',
          '</label>',
          '<input class="form-control" type="text" name="person[ni_number]" id="person_ni_number" />',
          '</div>'
        ]
      end
    end
  end

end
