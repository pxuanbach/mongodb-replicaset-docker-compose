# MongoDB ReplicaSet with Docker Compose

With the `docker-compose.yml` file, you can easily create replicaSet.

## Some things from me

- I have created and tested on Windows and Ubuntu environments.

- Some instructions suggested using the hosts of each service like *mongo1:27017*, *mongo2:27017*,... in the **ReplicaSet Config**. However, it didn't work for me. I tried connecting to MongoDB Compass but encountered the error *`getaddrinfo ENOTFOUND mongo1`*. Finally, I found this solution. [Link](https://www.mongodb.com/community/forums/t/docker-compose-replicasets-getaddrinfo-enotfound/14301/10)

- In my opinion, the names of each service only work within the scope of **Docker Compose**. So, if you include it in the **ReplicaSet Config**. Compass tries to find the reference of that service name in `/etc/hosts`. But since that name is not defined in `/etc/hosts`, it gives an error.

- As you can see, in the `rs-init.sh` file, I am using *localhost.mongors.com* (or *host.docker.internal*[?](https://docs.docker.com/desktop/networking/#i-want-to-connect-from-a-container-to-a-service-on-the-host) for Window) in the **ReplicaSet Config**. The purpose is to allow containers to connect to each other without needing to use the names of each service.

## How to use this one?

### Use Makefile

1. Create docker network and run all container in the `docker-compose.yml` file.

    ```bash
    make createnet
    
    make up
    ```

2. Make sure you have this one in `/etc/hosts` 😅.

    On Window environment, the path should be `C:/Windows/System32/drivers/etc/hosts`.
    ```sh
    # Added by Docker Desktop
    192.168.1.244 host.docker.internal 
    192.168.1.244 gateway.docker.internal
    # To allow the same kube context to work on the host and the container:
    127.0.0.1 kubernetes.docker.internal
    127.0.0.1 localhost.mongors.com     ### this one
    ```

    On Ubuntu environment, the path should be `/etc/hosts`.
    ```sh
    # Your system has configured 'manage_etc_hosts' as True.
    # As a result, if you wish for changes to this file to persist
    # then you will need to either
    # a.) make changes to the master file in /etc/cloud/templates/hosts.debian.tmpl
    # b.) change or remove the value of 'manage_etc_hosts' in
    #     /etc/cloud/cloud.cfg or cloud-config from user-data
    #
    127.0.0.1 localhost, localhost.mongors.com      ### this one
    ```


3. Init **ReplicaSet Config**.

    ```bash
    docker compose exec mongo3 ./docker-entrypoint-initdb.d/rs-init.sh

    # or
    make initrs
    ```

    Now, if you connect to a certain service, you will receive the following output.
    ```bash
    PS ...\mongodb-replicaset-docker-compose> make dbshell
    docker compose exec mongo2 mongo
    MongoDB shell version v4.4.23
    connecting to: mongodb://127.0.0.1:27017/?compressors=disabled&gssapiServiceName=mongodb
    Implicit session: session { "id" : UUID("e35ed408-0b4b-45cd-af22-2cca1efd4977") }
    MongoDB server version: 4.4.23
    ---
    The server generated these startup warnings when booting:
            2023-07-30T04:41:31.422+00:00: Access control is not enabled for the database. Read and write access to data and configuration is unrestricted
            2023-07-30T04:41:31.423+00:00: You are running this process as the root user, which is not recommended
            2023-07-30T04:41:31.423+00:00: /sys/kernel/mm/transparent_hugepage/enabled is 'always'. We suggest setting it to 'never'
    ---
    rs0:SECONDARY> 
    ```

4. Let try to connect.

    `
    mongodb://localhost.mongors.com:2727,localhost.mongors.com:2728,localhost.mongors.com:2729/?replicaSet=rs0
    `

    😁