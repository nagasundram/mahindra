module ApplicationHelper
  def sortable(column, title = nil)
    params = request.query_parameters
    title ||= column.titleize
    css_class = "current glyphicon "
    css_class += sort_direction == 'desc' ? "glyphicon-triangle-top" : "glyphicon-triangle-bottom"
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction, search: params[:search]}, {:class => css_class}
  end

  def popover(title, content)
    content_tag(:i, '', class: "glyphicon glyphicon-info-sign",
                        id: "#{title}_help",
                        title: title,
                        data: {
                            pop_over: true,
                            content: content
                        })
  end

end
