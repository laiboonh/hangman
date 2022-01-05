import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :b2, B2Web.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "G5AfPr0nzGfv4qxrAcS3Lk0VxhYOD7m0feU9hsoPwEgg3SeJlUN+IvnJqweeul+Q",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
