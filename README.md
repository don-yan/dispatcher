# Dispatcher

This is a dockerized Apache 2.4 server with the Adobe dispatcher
module 4.1.11. The image is based on the official `httpd:2.4` image
and adds the dispatcher module with corresponding configuration.

## Usage

First clone this repository:

```sh
git clone https://github.com/davidknezic/dispatcher.git
```

Then switch into the cloned repository and build the Docker image:

```sh
docker build -t dispatcher .
```

Next, simply start the dispatcher with your own setting:

```sh
docker run --rm -it -v /etc/httpd/conf/certs:/etc/httpd/conf/certs -e PUBLISH_HOSTNAME=192.168.99.100 -e PUBLISH_PORT=3000 -p 80:80 -p 443:443 dispatcher
```

## LICENSE

MIT
