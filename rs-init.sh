#!/bin/bash

mongo <<EOF
var config = {
    "_id": "rs0",
    "version": 1,
    "members": [
        {
            "_id": 1,
            "host": "host.docker.internal:2727",
            "priority": 3
        },
        {
            "_id": 2,
            "host": "host.docker.internal:2728",
            "priority": 2
        },
        {
            "_id": 3,
            "host": "host.docker.internal:2729",
            "priority": 1
        }
    ]
};
rs.initiate(config, { force: true });
rs.status();
EOF