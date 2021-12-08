defmodule Astro.Repo do
  use Ecto.Repo,
    otp_app: :ast,
    adapter: Ecto.Adapters.Postgres
end
