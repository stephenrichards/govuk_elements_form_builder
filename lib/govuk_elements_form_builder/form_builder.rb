module GovukElementsFormBuilder
  class FormBuilder < ActionView::Helpers::FormBuilder
    def text_field(name,*arg)
      @template.content_tag :div, class: 'form-group' do
        options = arg.extract_options!
        label_class = ["form-label"]
        label_class << options[:label][:class]] if options[:label][:class].present?
        label(name, class: label_class) + super
      end
    end
  end
end
