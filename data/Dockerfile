FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y fortune cowsay

WORKDIR /root

ENTRYPOINT [ "/usr/games/cowsay" ]
CMD ["-f", "vader"]
