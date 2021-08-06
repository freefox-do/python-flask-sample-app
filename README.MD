## Flaskr an example application written in Python/Flask

![Flask plus Codefresh](docker-flask-codefresh.jpg)

Original source code from https://github.com/pallets/flask/tree/master/examples/tutorial

## Docker instructions

To create a docker image execute: 

`docker build . -t flaskr`--build-arg AWS_ID=<> --build-arg AWS_KEY=<>

To run the docker image execute:

`docker run -p 5000:5000 flaskr` and visit with your browser http://localhost:5000

To run unit tests inside the container execute:

`docker run -it flaskr /bin/sh`

and then in the new command promt run

`pip install pytest && pytest`

## To use this project in Codefresh

There is also a [codefresh.yml](codefresh.yml) for easy usage with the [Codefresh](codefresh.io) CI/CD platform.

More details can be found in [Codefresh documentation](https://codefresh.io/docs/docs/getting-started/create-a-basic-pipeline/)

## DevOps Demo
- docker tag flaskr xinzhao.jfrog.io/product-docker/python-flask-sample-app:v1.0.0
- docker push xinzhao.jfrog.io/product-docker/python-flask-sample-app:v1.0.0
