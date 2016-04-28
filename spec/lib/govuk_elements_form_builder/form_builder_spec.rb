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
    split_output = output.gsub(">\n</textarea>", ' />').split("<").join("\n<").split(">").join(">\n").squeeze("\n").strip + '>'
    split_expected = expected.join("\n")
    expect(split_output).to eq split_expected
  end

  shared_examples_for 'input field' do |method, type|

    def element_for(method)
      method == :text_area ? 'textarea' : 'input'
    end

    def type_for(method, type)
      method == :text_area ? '' : %'type="#{type}" '
    end

    def size(method, size)
      method == :text_area ? '' : %'size="#{size}" '
    end

    it 'outputs label and input wrapped in div' do
      output = builder.send method, :name

      expect_equal output, [
        '<div class="form-group">',
        '<label class="form-label" for="person_name">',
        'Full name',
        '</label>',
        %'<#{element_for(method)} class="form-control" #{type_for(method, type)}name="person[name]" id="person_name" />',
        '</div>'
      ]
    end

    it 'adds custom class to input when passed class: "custom-class"' do
      output = builder.send method, :name, class: "custom-class"

      expect_equal output, [
        '<div class="form-group">',
        '<label class="form-label" for="person_name">',
        'Full name',
        '</label>',
        %'<#{element_for(method)} class="custom-class form-control" #{type_for(method, type)}name="person[name]" id="person_name" />',
        '</div>'
      ]
    end

    it 'adds custom classes to input when passed class: ["custom-class", "another-class"]' do
      output = builder.send method, :name, class: ["custom-class", "another-class"]

      expect_equal output, [
        '<div class="form-group">',
        '<label class="form-label" for="person_name">',
        'Full name',
        '</label>',
        %'<#{element_for(method)} class="custom-class another-class form-control" #{type_for(method, type)}name="person[name]" id="person_name" />',
        '</div>'
      ]
    end

    it 'passes options passed to text_field onto super text_field implementation' do
      output = builder.send method, :name, size: 100
      expect_equal output, [
        '<div class="form-group">',
        '<label class="form-label" for="person_name">',
        'Full name',
        '</label>',
        %'<#{element_for(method)} #{size(method, 100)}class="form-control" #{type_for(method, type)}name="person[name]" id="person_name" />',
        '</div>'
      ]
    end

    context 'when hint text provided' do
      it 'outputs hint text in span inside label' do
        output = builder.send method, :ni_number
        expect_equal output, [
          '<div class="form-group">',
          '<label class="form-label" for="person_ni_number">',
          'National Insurance number',
          '<span class="form-hint">',
          'It’ll be on your last payslip. For example, JH 21 90 0A.',
          '</span>',
          '</label>',
          %'<#{element_for(method)} class="form-control" #{type_for(method, type)}name="person[ni_number]" id="person_ni_number" />',
          '</div>'
        ]
      end
    end

    context 'when fields_for used' do
      it 'outputs label and input with correct ids' do
        resource.address = Address.new
        output = builder.fields_for(:address) do |f|
          f.send method, :postcode
        end
        expect_equal output, [
          '<div class="form-group">',
          '<label class="form-label" for="person_address_attributes_postcode">',
          'Postcode',
          '</label>',
          %'<#{element_for(method)} class="form-control" #{type_for(method, type)}name="person[address_attributes][postcode]" id="person_address_attributes_postcode" />',
          '</div>'
        ]
      end
    end

    context 'when validation error on object' do
      it 'outputs error message in span inside label' do
        resource.valid?
        output = builder.send method, :name

        expect_equal output, [
          '<div class="form-group error" id="error_person_name">',
          '<label class="form-label" for="person_name">',
          'Full name',
          '<span class="error-message" id="error_message_person_name">',
          "Full name is required",
          '</span>',
          '</label>',
          %'<#{element_for(method)} aria-describedby="error_message_person_name" class="form-control" #{type_for(method, type)}name="person[name]" id="person_name" />',
          '</div>'
        ]
      end
    end

    context 'when validation error on child object' do
      it 'outputs error message in span inside label' do
        resource.address = Address.new
        resource.address.valid?

        output = builder.fields_for(:address) do |f|
          f.send method, :postcode
        end

        expect_equal output, [
          '<div class="form-group error" id="error_person_address_attributes_postcode">',
          '<label class="form-label" for="person_address_attributes_postcode">',
          'Postcode',
          '<span class="error-message" id="error_message_person_address_attributes_postcode">',
          "Postcode is required",
          '</span>',
          '</label>',
          %'<#{element_for(method)} aria-describedby="error_message_person_address_attributes_postcode" class="form-control" #{type_for(method, type)}name="person[address_attributes][postcode]" id="person_address_attributes_postcode" />',
          '</div>'
        ]
      end
    end

    context 'when validation error on twice nested child object' do
      it 'outputs error message in span inside label' do
        resource.address = Address.new
        resource.address.country = Country.new
        resource.address.country.valid?

        output = builder.fields_for(:address) do |address|
          address.fields_for(:country) do |country|
            country.send method, :name
          end
        end

        expect_equal output, [
          '<div class="form-group error" id="error_person_address_attributes_country_attributes_name">',
          '<label class="form-label" for="person_address_attributes_country_attributes_name">',
          'Country',
          '<span class="error-message" id="error_message_person_address_attributes_country_attributes_name">',
          "Country is required",
          '</span>',
          '</label>',
          %'<#{element_for(method)} aria-describedby="error_message_person_address_attributes_country_attributes_name" class="form-control" #{type_for(method, type)}name="person[address_attributes][country_attributes][name]" id="person_address_attributes_country_attributes_name" />',
          '</div>'
        ]
      end
    end

  end

  describe '#text_field' do
    include_examples 'input field', :text_field, :text
  end

  describe '#text_area' do
    include_examples 'input field', :text_area, nil
  end

  describe '#email_field' do
    include_examples 'input field', :email_field, :email
  end

  describe "#number_field" do
    include_examples 'input field', :number_field, :number
  end

  describe '#password_field' do
    include_examples 'input field', :password_field, :password
  end

  describe '#phone_field' do
    include_examples 'input field', :phone_field, :tel
  end

  describe '#range_field' do
    include_examples 'input field', :range_field, :range
  end

  describe '#search_field' do
    include_examples 'input field', :search_field, :search
  end

  describe '#telephone_field' do
    include_examples 'input field', :telephone_field, :tel
  end

  describe '#url_field' do
    include_examples 'input field', :url_field, :url
  end

  describe '#radio_button_fieldset' do
    it 'outputs radio buttons wrapped in labels' do
      output = builder.radio_button_fieldset :location, choices: [:ni, :isle_of_man_channel_islands, :british_abroad]
      expect_equal output, [
        '<fieldset>',
        '<legend class="heading-medium">',
        'Where do you live?',
        '<span class="form-hint">',
        'Select from these options because you answered you do not reside in England, Wales, or Scotland',
        '</span>',
        '</legend>',
        '<label class="block-label" for="person_location_ni">',
        '<input type="radio" value="ni" name="person[location]" id="person_location_ni" />',
        'Northern Ireland',
        '</label>',
        '<label class="block-label" for="person_location_isle_of_man_channel_islands">',
        '<input type="radio" value="isle_of_man_channel_islands" name="person[location]" id="person_location_isle_of_man_channel_islands" />',
        'Isle of Man or Channel Islands',
        '</label>',
        '<label class="block-label" for="person_location_british_abroad">',
        '<input type="radio" value="british_abroad" name="person[location]" id="person_location_british_abroad" />',
        'I am a British citizen living abroad',
        '</label>',
        '</fieldset>'
      ]
    end

    it 'outputs yes/no choices when no choices specified, and adds "inline" class to fieldset when passed "inline: true"' do
      output = builder.radio_button_fieldset :has_user_account, inline: true
      expect_equal output, [
        '<fieldset class="inline">',
        '<legend class="heading-medium">',
        'Do you already have a personal user account?',
        '</legend>',
        '<label class="block-label" for="person_has_user_account_yes">',
        '<input type="radio" value="yes" name="person[has_user_account]" id="person_has_user_account_yes" />',
        'Yes',
        '</label>',
        '<label class="block-label" for="person_has_user_account_no">',
        '<input type="radio" value="no" name="person[has_user_account]" id="person_has_user_account_no" />',
        'No',
        '</label>',
        '</fieldset>'
      ]
    end

  end

  describe '#check_box_fieldset' do
    it 'outputs checkboxes wrapped in labels' do
      resource.waste_transport = WasteTransport.new
      output = builder.fields_for(:waste_transport) do |f|
        f.check_box_fieldset :waste_transport, [:animal_carcasses, :mines_quarries, :farm_agricultural]
      end

      expect_equal output, [
        '<fieldset>',
        '<legend class="heading-medium">',
        'Which types of waste do you transport regularly?',
        '<span class="form-hint">',
        'Select all that apply',
        '</span>',
        '</legend>',
        '<label class="block-label" for="person_waste_transport_attributes_animal_carcasses">',
        '<input name="person[waste_transport_attributes][animal_carcasses]" type="hidden" value="0" />',
        '<input type="checkbox" value="1" name="person[waste_transport_attributes][animal_carcasses]" id="person_waste_transport_attributes_animal_carcasses" />',
        'Waste from animal carcasses',
        '</label>',
        '<label class="block-label" for="person_waste_transport_attributes_mines_quarries">',
        '<input name="person[waste_transport_attributes][mines_quarries]" type="hidden" value="0" />',
        '<input type="checkbox" value="1" name="person[waste_transport_attributes][mines_quarries]" id="person_waste_transport_attributes_mines_quarries" />',
        'Waste from mines or quarries',
        '</label>',
        '<label class="block-label" for="person_waste_transport_attributes_farm_agricultural">',
        '<input name="person[waste_transport_attributes][farm_agricultural]" type="hidden" value="0" />',
        '<input type="checkbox" value="1" name="person[waste_transport_attributes][farm_agricultural]" id="person_waste_transport_attributes_farm_agricultural" />',
        'Farm or agricultural waste',
        '</label>',
        '</fieldset>'
      ]
    end

  end
end
