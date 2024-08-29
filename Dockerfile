FROM alpine:latest AS parallel

RUN apk add --no-cache parallel

FROM caddy:latest AS caddy

COPY Caddyfile ./

RUN caddy fmt --overwrite Caddyfile

FROM browserless/chrome:1-chrome-stable

ENV ENABLE_DEBUGGER=false
ENV DEBUG=browserless:server
ENV PRINT_NETWORK_INFO=false
ENV TOKEN=$TOKEN
ENV MAX_CONCURRENT_SESSIONS=200
ENV DEFAULT_LAUNCH_ARGS="[\"--no-sandbox\", \
              \"--disable-setuid-sandbox\", \
              \"--disable-dev-shm-usage\", \
              \"--disable-accelerated-2d-canvas\", \
              \"--no-first-run\", \
              \"--no-zygote\", \
              \"--single-process\", \
              \"--disable-gpu\", \
              \"--hide-scrollbars\", \
              \"--disable-web-security\", \
              \"--font-render-hinting=none\", \
              \"--enable-font-antialiasing\", \
              \"--force-color-profile=srgb\", \
              \"--autoplay-policy=user-gesture-required\", \
              \"--disable-background-networking\", \
              \"--disable-background-timer-throttling\", \
              \"--disable-backgrounding-occluded-windows\", \
              \"--disable-breakpad\", \
              \"--disable-client-side-phishing-detection\", \
              \"--disable-component-update\", \
              \"--disable-default-apps\", \
              \"--disable-domain-reliability\", \
              \"--disable-extensions\", \
              \"--disable-features=AudioServiceOutOfProcess\", \
              \"--disable-hang-monitor\", \
              \"--disable-ipc-flooding-protection\", \
              \"--disable-notifications\", \
              \"--disable-offer-store-unmasked-wallet-cards\", \
              \"--disable-popup-blocking\", \
              \"--disable-print-preview\", \
              \"--disable-prompt-on-repost\", \
              \"--disable-renderer-backgrounding\", \
              \"--disable-setuid-sandbox\", \
              \"--disable-speech-api\", \
              \"--disable-sync\", \
              \"--hide-scrollbars\", \
              \"--ignore-gpu-blacklist\", \
              \"--metrics-recording-only\", \
              \"--mute-audio\", \
              \"--no-default-browser-check\", \
              \"--no-first-run\", \
              \"--no-pings\", \
              \"--no-sandbox\", \
              \"--no-zygote\", \
              \"--password-store=basic\", \
              \"--use-gl=swiftshader\", \
              \"--window-size=794,1123\", \
              \"--use-mock-keychain\"]"

COPY --from=caddy /srv/Caddyfile ./

COPY --from=caddy /usr/bin/caddy /usr/bin/caddy

COPY --from=parallel /usr/bin/parallel /usr/bin/parallel

COPY --chmod=755 scripts/* ./

ENTRYPOINT ["/bin/sh"]

CMD ["start.sh"]
