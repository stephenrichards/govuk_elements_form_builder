module GovukElementsFormBuilder
  class FormBuilder < ActionView::Helpers::FormBuilder
    def text_field(name,*arg)
      @template.content_tag :div, class: 'form-group' do
        options = arg.extract_options!

        label_class = ["form-label"]

        text_field_class = ["form-control"]

        options[:class] = text_field_class

        label(name, class: label_class) + super(name, options.except(:label))
      end
    end
  end
end
