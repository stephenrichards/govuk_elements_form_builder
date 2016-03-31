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

    context 'when validation error on object' do
      it 'outputs error message in span inside label' do
        resource.valid?
        output = builder.text_field :name

        expect_equal output, [
          '<div class="form-group error">',
          '<label id="error_person_name" class="form-label" for="person_name">',
          'Full name',
          '<span class="error-message" id="error_message_person_name">',
          "Name can't be blank",
          '</span>',
          '</label>',
          '<input aria-describedby="error_message_person_name" class="form-control" type="text" name="person[name]" id="person_name" />',
          '</div>'
        ]
      end
    end
  end

  describe '#email_field' do
    it 'outputs label and input wrapped in div' do
      output = builder.email_field :email_work
      expect_equal output, [
        '<div class="form-group">',
        '<label class="form-label" for="person_email_work">',
        'Work email address',
        '</label>',
        '<input class="form-control" type="email" name="person[email_work]" id="person_email_work" />',
        '</div>'
      ]
    end

    context 'when hint text provided' do
      it 'outputs hint text in span inside label' do
        output = builder.email_field :email_home
        expect_equal output, [
          '<div class="form-group">',
          '<label class="form-label" for="person_email_home">',
          'Home email address',
          '<span class="form-hint">',
          'For eg. John.Smith@example.com',
          '</span>',
          '</label>',
          '<input class="form-control" type="email" name="person[email_home]" id="person_email_home" />',
          '</div>'
        ]
      end
    end
  end

  describe '#password_field' do
    it 'outputs label and input wrapped in div' do
      output = builder.password_field :password
      expect_equal output, [
        '<div class="form-group">',
        '<label class="form-label" for="person_password">',
        'Password',
        '</label>',
        '<input class="form-control" type="password" name="person[password]" id="person_password" />',
        '</div>'
      ]
    end

    context 'when hint text provided' do
      it 'outputs hint text in span inside label' do
        output = builder.password_field :password_confirmation
        expect_equal output, [
          '<div class="form-group">',
          '<label class="form-label" for="person_password_confirmation">',
          'Confirm password',
          '<span class="form-hint">',
          'Password should match',
          '</span>',
          '</label>',
          '<input class="form-control" type="password" name="person[password_confirmation]" id="person_password_confirmation" />',
          '</div>'
        ]
      end
    end
  end

end
