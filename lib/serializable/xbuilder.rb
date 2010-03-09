module Serializable
  class XBuilder < ::ActionView::TemplateHandler
    include ActionView::TemplateHandlers::Compilable

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

  end
end

ActionView::Template.register_template_handler(:xbuilder, Serializable::XBuilder)
