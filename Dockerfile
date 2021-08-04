FROM python:3.8.2-alpine3.11

RUN apt-get update
RUN apt-get install -q -y wget
RUN cd / ; wget https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py

COPY awslogs.conf.dummy /
RUN python /awslogs-agent-setup.py -n -r ap-southeast-2 -c ./awslogs.conf.dummy
# ONBUILD ADD aws.conf       /var/awslogs/etc/aws.conf
# ONBUILD ADD awslogs.conf /var/awslogs/etc/awslogs.conf

COPY run-services.sh /
RUN chmod a+x /run-services.sh
CMD /run-services.sh

ENV FLASK_APP=flaskr
ENV FLASK_ENV=development

COPY . /app

WORKDIR /app

RUN pip install --editable .

RUN flask init-db

EXPOSE 5000

CMD [ "flask", "run", "--host=0.0.0.0" ]



