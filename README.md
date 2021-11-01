# ft_server

ft_server is an example of an LEMP-stack implementation as an introduction to docker

## Project description

This project is an introduction to servers and working in containers.
The end result is a small server which is set-up in 1 Dockerfile and combines a wordpress site, a database with mysql and nginx as an engine.

## How to use
> If docker is installed on your machine, execute the following commands:

```shell
git clone https://github.com/kasderooi/ft_server.git
cd ft_server
docker build -t ft_server .
docker run -it -p 80:80 -p 443:443 ft_server
```

> Go to http://localhost (your browser will warn you about an unsafe connection)
