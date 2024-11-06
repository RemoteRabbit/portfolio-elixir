defmodule PortfolioWeb.ProjectLive.Show do
  use PortfolioWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, "Project Details")
     |> assign(:project_id, id)}
  end
end
