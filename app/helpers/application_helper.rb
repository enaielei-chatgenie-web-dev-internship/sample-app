module ApplicationHelper
    BASE_TITLE = "Sample App"
    def get_title(title="", separator=" | ")
        if title.empty?()
            return BASE_TITLE
        else
            return "#{BASE_TITLE}#{separator}#{title}"
        end
    end
end
