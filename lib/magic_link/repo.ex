defmodule MagicLink.Repo do
  use Ecto.Repo,
    otp_app: :magic_link,
    adapter: Ecto.Adapters.Postgres
end
