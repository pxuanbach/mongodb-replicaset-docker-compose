#!/bin/bash

mongo <<EOF
var config = {
    "_id": "rs0",
    "version": 1,
    "members": [
        {
            "_id": 1,
            "host": "localhost.mongors.com:27021",
            "priority": 3
        },
        {
            "_id": 2,
            "host": "localhost.mongors.com:27022",
            "priority": 2
        },
        {
            "_id": 3,
            "host": "localhost.mongors.com:27023",
            "priority": 1
        }
    ]
};
rs.initiate(config, { force: true });
rs.status();
EOF