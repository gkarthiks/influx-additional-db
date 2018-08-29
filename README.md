[![Build Status](https://travis-ci.org/gkarthiks/influx-additional-db.svg?branch=master)](https://travis-ci.org/gkarthiks/influx-additional-db)
# influx-additional-db
Since InfluxDB image suports creation of only one database during the time of container startup, this image creates additional Databases in InfluxDB after container startup.

## Execution method:
Image has `shell` and the options should be passed as below

> ./createdb.sh -url http://localhost:8086 -db db1,db2

## How to use:

This image can be used with the `influxdb's helm chart` as a `post-install` hook to create multiple databases in the InfluxDB. 
