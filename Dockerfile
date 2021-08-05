FROM python:3.8.2-alpine3.11

# RUN apk update
# RUN apk add -q wget
# RUN apk add openrc --no-cache

# # install awslogs agent /
# RUN cd / ; wget https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py
# RUN pip install awslogs
# RUN pip install awscli-cwlogs
# COPY ./aws-log/awslogs.conf.dummy /var/awslogs/etc/awslogs.conf

ENV FLASK_APP=flaskr
ENV FLASK_ENV=development

COPY . /app

WORKDIR /app

RUN pip install --editable .

RUN flask init-db

EXPOSE 5000

CMD [ "flask", "run", "--host=0.0.0.0" ]





