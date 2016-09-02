module TranslationHelper
  def with_translations(locale, translations)
    original_backend = I18n.backend
    original_available_locales = I18n.available_locales
    original_locale = I18n.locale

    I18n.available_locales = [locale]
    I18n.locale = locale
    I18n.backend = I18n::Backend::KeyValue.new Hash.new, true
    I18n.backend.store_translations locale, translations

    yield
  ensure
    I18n.backend = original_backend
    I18n.available_locales = original_available_locales
    I18n.locale = original_locale
  end
end
