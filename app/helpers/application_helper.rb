module ApplicationHelper
    BASE_TITLE = "Sample App"
    def get_title(title="", separator=" | ")
        if title.empty?()
            return BASE_TITLE
        else
            return "#{BASE_TITLE}#{separator}#{title}"
        end
    end

    def is_page(controller_name, *action_names)
        name = controller.controller_name
        action = controller.action_name
        return name == controller_name && action_names.include?(action)
    end

    def page_link(properties={})
        props = properties
        options = props[:options] || {}
        html_options = props[:html_options] || {}
        # page_param = props[:page_param] || :page
        # page = props[:page] || 0

        body = props[:body] || ""
        # active = props[:active] || false
        # disabled = props[:disabled] || false

        # options = options.dup()
        # html_options = html_options.dup()
        
        # options[page_param] = page
        # cls = html_options[:class]
        # cls ||= ""
        
        # cls += " active" if active
        # cls += " disabled" if disabled

        # html_options[:class] = cls

        return link_to(body || page.to_s(), options, html_options)
    end
end
