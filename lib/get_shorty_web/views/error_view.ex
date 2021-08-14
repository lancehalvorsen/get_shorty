defmodule GetShortyWeb.ErrorView do
  use GetShortyWeb, :view

  def render("404.html", _assigns) do
    "We were not able to locate that shortened URL. Please check it and try again."
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
