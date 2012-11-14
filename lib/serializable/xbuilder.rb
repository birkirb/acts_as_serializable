module Serializable
  if defined?(Rails)
    RAILS_2 = Rails::VERSION::MAJOR == 2
  else
    RAILS_2 = true
  end
  parent  = RAILS_2 ? ::ActionView::TemplateHandler : Object

  class XBuilder < parent
    include ActionView::TemplateHandlers::Compilable if Serializable::RAILS_2
    def compile(template)
      compiled_code = <<-CODE
        format = params[:format]

        if format && :json == format.to_sym
          _set_controller_content_type(Mime::JSON)
          xbuilder = ::Builder::HashStructure.new
          #{template.source}
          xbuilder.target!.to_json
        else
          _set_controller_content_type(Mime::XML)
          xbuilder = ::Builder::XmlMarkup.new
          #{template.source}
          xbuilder.target!
        end
      CODE
      compiled_code
    end

    alias_method :call, :compile
  end
end

ActionView::Template.register_template_handler(:xbuilder, Serializable::XBuilder)