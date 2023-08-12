# ---- Build Stage ----
FROM elixir:1.14.1 AS app_builder

# Set environment variables for building the application
ENV MIX_ENV=prod \
  LANG=C.UTF-8 \
  PATH=/root/.mix/escripts:$PATH

# Install hex and rebar
RUN apt-get update && \
  mix local.hex --force && \
  mix local.rebar --force

# Create the application build directory
RUN mkdir /app
WORKDIR /app

# Copy over all the necessary application files and directories
# See .dockerignore for ignored files
COPY . .

# Compile and build the release
RUN mix deps.compile
RUN mix phx.digest
RUN mix release
RUN mv _build/prod/rel/kantox/ /release/


# ---- Application Stage ----
FROM debian:bullseye-slim AS app

ENV LANG=C.UTF-8

# Install openssl
RUN apt-get update && apt-get install -y openssl curl

EXPOSE 9091

# Copy over the build artifact from the previous step and create a non root user
WORKDIR /app
COPY --from=app_builder /release/ .

# Run the app
CMD ["./bin/kantox", "start"]