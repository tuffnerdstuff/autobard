FROM rust:1.51 as builder
WORKDIR /usr/src/bard
RUN apt-get update && apt-get install -y git && git clone https://github.com/vojtechkral/bard.git .
RUN cargo install -f bard

FROM debian:buster-slim
RUN apt-get update && apt-get install -y texlive-xetex rclone && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/local/cargo/bin/bard /usr/local/bin/bard
COPY render_dir /usr/local/bin/render_dir
COPY entrypoint /usr/local/bin/entrypoint
WORKDIR /songbooks
ENV RCLONE_CONFIG=/etc/rclone/rclone.conf
ENV AUTOBARD_INTERVAL=10
ENV AUTOBARD_REMOTE_NAME=drive
ENV AUTOBARD_REMOTE_DIR=/Songbooks
ENTRYPOINT ["entrypoint"]
CMD ["help"]
