ARG SYSTEM_TIMEZONE=Europe/London
ARG GATEWAY_RS_RELEASE=v1.0.2

FROM balenalib/raspberry-pi-debian:buster-run

# Move to working directory
WORKDIR /opt/gatewayrs

ARG SYSTEM_TIMEZONE
ARG GATEWAY_RS_RELEASE
ENV GATEWAY_RS_RELEASE $GATEWAY_RS_RELEASE

# Intall dependencies
RUN \
    apt-get update && \
    DEBIAN_FRONTEND="noninteractive" \
    TZ="$SYSTEM_TIMEZONE" \
        apt-get -y install \
        wget=1.20.1-1.1 \
        python3=3.7.3-1 \
        ca-certificates=20200601~deb10u2 \
        --no-install-recommends && \
        apt-get autoremove -y && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*

# Pull in latest helium gatewayrs deb file and install

#RUN wget https://github.com/helium/gateway-rs/releases/download/"$GATEWAY_RS_RELEASE"/helium-gateway-"$GATEWAY_RS_RELEASE"-raspi01.deb
RUN wget -O - https://github.com/helium/gateway-rs/releases/download/v1.0.2/helium-gateway-1.0.2-arm-unknown-linux-gnueabihf.tar.gz | tar zxf -
#RUN dpkg -i helium-gateway-*-raspi01.deb
#ADD helium-gateway-1.0.2-arm-unknown-linux-gnueabihf.tar.gz ./

# Copy start script and settings file#
COPY start-gatewayrs.sh .
#COPY settings.toml.template /etc/helium_gateway/settings.toml.template
RUN mkdir /etc/helium_gateway/
RUN cp settings.toml /etc/helium_gateway/
RUN cp helium_gateway /usr/bin/
#COPY settings.toml /etc/helium_gateway/settings.toml
#COPY helium_gateway /usr/bin/helium_gateway

# Run start-gatewayrs script
ENTRYPOINT ["/opt/gatewayrs/start-gatewayrs.sh"]
