FROM tailscale/tailscale:stable AS tailscale_bin

FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    iproute2 \
    iptables \
    kmod \
    procps \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=tailscale_bin /usr/local/bin/tailscale /app/tailscale
COPY --from=tailscale_bin /usr/local/bin/tailscaled /app/tailscaled

RUN mkdir -p /var/run/tailscale

COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh /app/tailscale /app/tailscaled

# Переменные окружения (заполни своими значениями)
ENV FLY_REGION="ams"

EXPOSE 41641/udp

ENTRYPOINT ["/app/start.sh"]
