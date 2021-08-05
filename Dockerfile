# FROM python:3.8.2-alpine3.11

FROM python:3.8.10-buster

# Download and install aws-cloudwatch-agent
RUN apt-get update &&  \
    apt-get install -y ca-certificates curl && \
    rm -rf /var/lib/apt/lists/*

RUN curl -O https://s3.amazonaws.com/amazoncloudwatch-agent/debian/amd64/latest/amazon-cloudwatch-agent.deb && \
    dpkg -i -E amazon-cloudwatch-agent.deb && \
    rm -rf /tmp/* && \
    rm -rf /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard && \
    rm -rf /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl && \
    rm -rf /opt/aws/amazon-cloudwatch-agent/bin/config-downloader

# Generate credential file 
RUN mkdir /root/.aws
RUN echo "[AmazonCloudWatchAgent]" >> /root/.aws/credentials
RUN echo "aws_access_key_id=${AWS_ID}" >> /root/.aws/credentials
RUN echo "aws_secret_access_key=${AWS_KEY}" >> /root/.aws/credentials

RUN echo "[AmazonCloudWatchAgent]" >> /root/.aws/config
RUN echo "output = text" >> /root/.aws/config
RUN echo "region = ap-southeast-2" >> /root/.aws/config

RUN echo "[credentials]" >> /opt/aws/amazon-cloudwatch-agent/etc/common-config.toml
RUN echo '   shared_credential_profile = "AmazonCloudWatchAgent"' >> /opt/aws/amazon-cloudwatch-agent/etc/common-config.toml
RUN echo '   shared_credential_file = "/root/.aws/credentials"' >> /opt/aws/amazon-cloudwatch-agent/etc/common-config.toml

# Generate config file for cloudwatch agent
COPY ./aws-log/amazon-cloudwatch-agent.json /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

RUN ./opt/aws/amazon-cloudwatch-agent/bin/start-amazon-cloudwatch-agent

ENV FLASK_APP=flaskr
ENV FLASK_ENV=development

COPY . /app

WORKDIR /app

RUN pip install --editable .

RUN flask init-db

EXPOSE 5000

CMD [ "flask", "run", "--host=0.0.0.0" ]





