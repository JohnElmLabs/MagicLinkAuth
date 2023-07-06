# MagicLink Authentication

This repository demonstrates how to extend `mix phx.gen.auth`'s default capabilities by adding "magic link" authentication. That is, one-time sign-in links delivered to your email.

Visit [John Elm Lab's Writeup](https://johnelmlabs.com/posts/magic-link-auth/) for more info.

## Run the demo:

To start the Phoenix server:


  * Run `asdf install` to install the correct elixir and erlang versions
  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

To demonstrate the sign-in flow:

1. Create an account at [http://localhost:4000/users/register](http://localhost:4000/users/register)
2. Log out of the account (Sign out button at top right of home page)
3. Navigate to [http://localhost:4000/users/log_in](http://localhost:4000/users/log_in)
4. Enter email and click "Send me a link"
5. Navigate to the mailbox [http://localhost:4000/dev/mailbox](http://localhost:4000/dev/mailbox) and find the magic link email
6. Navigate to the sign in URL contained in the email
7. Done!
