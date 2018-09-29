FROM ubuntu:16.04

RUN apt-get update; apt-get -y upgrade; apt-get clean

RUN apt-get install -y git curl tar make jq; apt-get clean

# dependencies for "bosh create-env" command
RUN apt-get install -y build-essential zlibc zlib1g-dev ruby ruby-dev openssl libxslt-dev libxml2-dev libssl-dev libreadline6 libreadline6-dev libyaml-dev libsqlite3-dev sqlite3; apt-get clean

# azure-cli
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ xenial main" | tee /etc/apt/sources.list.d/azure-cli.list
RUN curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN apt-get install -y apt-transport-https
RUN apt-get update; apt-get install -y azure-cli=2.0.46-1~xenial; apt-get clean; az -v

# bosh-cli
RUN curl -Lo ./bosh https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-5.3.1-linux-amd64
RUN chmod +x ./bosh; mv ./bosh /usr/local/bin/bosh; bosh -v
