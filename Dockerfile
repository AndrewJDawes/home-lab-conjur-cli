FROM cyberark/conjur-cli:8 AS base

USER root

ENV CONJUR_SERVER_APPLIANCE_URL=""
ENV CONJUR_ORG_ACCOUNT=""
ENV CONJUR_USERNAME=""
ENV CONJUR_PASSWORD=""
ENV CONJUR_CLI_INSECURE=false

COPY src /
RUN chmod +x /entrypoint.sh

USER cli

ENTRYPOINT ["/entrypoint.sh"]
CMD ["conjur", "help"]

FROM base AS dev

USER root

# Install gzip
RUN microdnf install -y gzip git sudo iputils hostname findutils less nano net-tools bind-utils;

# Make the "cli" user a sudoer without any password
RUN echo "cli ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER cli
