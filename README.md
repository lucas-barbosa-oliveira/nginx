# Reverse proxy configuration with NGINX

---

## Prerequisites


- Docker Engine 18.06.0+

  - **Linux:** Follow all the steps present in the [official documentation](https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce)

- Docker Compose 1.22.0+
  -  Follow all the steps present in the [official documentation](https://docs.docker.com/compose/install/)

## Set the environment variables

The file `.env.example` contains all the environment variables required by the services being deployed.

Copy and paste with the file `.env.example` with the name `.env` to make the Docker Compose use the environment variables defined in this file:

```sh
cp .env.example .env
```

Variables to define the ports of services to be exposed:

| Variable | Description | Example |
| -------- | ----------- | ------- |
| `NG_PORT_HTTP` |  Port used by the NGINX service to listen for HTTP request. | `80` |
| `NG_PORT_HTTPS` | Port used by the NGINX service to listen for HTTPS request. | `443` |

If you already have valid HTTPS certificates to use on the platform, you need to point the path of each of them in the appropriate environment variables:

| Variable | Description | Example |
| -------- | ----------- | ------- |
| `AG_KEY_PATH` | NGINX private key. | `mycerts/privkey.pem` |
| `AG_CERT_PATH` | NGINX domain certificate/public key. | `mycerts/fullchain.pem` |



| Variable | Description | Example |
| -------- | ----------- | ------- |
| `DOMAIN_SERVICES` | Path to the location that contains the mapping of domains for services. | `./config/domain_to_service_map.txt` |

## Building and Deploying the containers

```sh
docker-compose up -d
 ```

It will build the containers and run the platform as specified in the file `docker-compose.yml`, opening a log screen with the logs of all the services started.

## Stopping the execution

If you are still in the log screen press `Ctrl + C` just one time for graceful stop, two times to force stop

To stop all containers created by docker-compose, you need to go to the folder where docker-compose.yml is and run:
```sh
docker-compose down
 ```

To stop just one container:

```ssh
docker stop my_container
 ```

## Other useful commands

Restarts Docker. Useful in critical situations:

```sh
sudo service docker restart
 ```

Check all containers and its status:

```sh
docker container ls
 ```

Enter in the shell or bash of a particular container:

```sh
docker exec -it container_id /bin/bash
 ```

Stop all containers:

```sh
docker stop $(docker ps -a -q)
 ```

Delete all containers:

```sh
docker rm -f $(docker ps -a -q)
 ```

Delete all volumes:

```sh
docker volume rm $(docker volume ls -q)
```

Delete all container images:

```sh
docker rmi -f $(sudo docker images -q)
```
