module GovukElementsFormBuilder
  class FormBuilder < ActionView::Helpers::FormBuilder

    delegate :content_tag, :tag, to: :@template
    delegate :errors, to: :@object

    def initialize *args
      ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
        add_error_to_html_tag! html_tag
      end
      super
    end

    %w[text_field email_field password_field].each do |method_name|
      define_method(method_name) do |attribute, *args|
        content_tag :div, class: form_group_classes(attribute) do
          options = args.extract_options!
          text_field_class = ["form-control"]
          options[:class] = text_field_class

          label = label(attribute, class: "form-label")
          add_hint label, attribute
          (label + super(attribute, options.except(:label)) ).html_safe
        end
      end
    end

    private

    def add_error_to_html_tag! html_tag
      case html_tag
      when /^<label/
        add_error_to_label! html_tag
      when /^<input/
        add_error_to_input! html_tag
      else
        html_tag
      end
    end

    def add_error_to_label! html_tag
      field = html_tag[/for="([^"]+)"/, 1]
      attribute = field.sub(@object_name.to_s + '_', '').to_sym
      message = errors.full_messages_for(attribute).first
      html_tag.sub!('label', %'label id="error_#{field}"')
      html_tag.sub!('</label',
        %'<span class="error-message" id="error_message_#{field}">#{message}</span></label')
    end

    def add_error_to_input! html_tag
      field = html_tag[/id="([^"]+)"/, 1]
      html_tag.sub!('input', %'input aria-describedby="error_message_#{field}"')
    end

    def form_group_classes attribute
      classes = 'form-group'
      classes += ' error' if error_for? attribute
      classes
    end

    def error_for? attribute
      errors.messages.key?(attribute) && !errors.messages[attribute].empty?
    end

    def error_id attribute
      "error-#{@object_name.tr('[]','-')}-#{attribute}".squeeze('-')
    end

    def add_hint label, name
      if hint = hint_text(name)
        hint_span = content_tag(:span, hint, class: 'form-hint')
        label.sub!('</label>', hint_span + '</label>'.html_safe)
      end
    end

    def hint_text name
      I18n.t("#{object_name}.#{name}", default: "", scope: 'helpers.hint').presence
    end
  end
end
