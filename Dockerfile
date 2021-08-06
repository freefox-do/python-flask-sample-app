FROM python:3.8.2-alpine3.11

ARG AWS_KEY
ARG AWS_ID
ENV FLASK_APP=flaskr
ENV FLASK_ENV=development

# Setup AWS awscli-cwlogs
RUN pip install awscli-cwlogs
# Setup AWS credentials
RUN mkdir /root/.aws
RUN echo "[devops]" > /root/.aws/credentials
RUN echo "aws_access_key_id = ${AWS_ID}" >> /root/.aws/credentials
RUN echo "aws_secret_access_key = ${AWS_KEY}" >> /root/.aws/credentials
RUN echo "[devops]" > /root/.aws/config
RUN echo "region = ap-southeast-2" >> /root/.aws/config
RUN echo "output = json" >> /root/.aws/config
RUN aws configure set plugins.cwlogs cwlogs
RUN touch /var/log/post.log

COPY . /app

WORKDIR /app

RUN pip install --editable .

RUN flask init-db

EXPOSE 5000

CMD [ "flask", "run", "--host=0.0.0.0" ]





