[![Build Status](https://travis-ci.org/gkarthiks/influx-additional-db.svg?branch=master)](https://travis-ci.org/gkarthiks/influx-additional-db)
# influx-additional-db
Since InfluxDB image suports creation of only one database during the time of container startup, this image creates additional Databases in InfluxDB after container startup.

## Execution method:
Image has `shell` and the options should be passed as below

> ./createdb.sh -url http://localhost:8086 -db db1,db2

## How to use:

This image can be used with the `influxdb's helm chart` as a `post-install` hook to create multiple databases in the InfluxDB. 

## Example helm post-install hook:

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: influx-additional-dbs
  labels:
    app.kubernetes.io/managed-by: {{.Release.Service | quote }}
    app.kubernetes.io/instance: {{.Release.Name | quote }}
    helm.sh/chart: "{{.Chart.Name}}-{{.Chart.Version}}"
  annotations:
    "helm.sh/hook": post-install
    "helm.sh/hook-weight": "-5"
    "helm.sh/hook-delete-policy": hook-succeeded
spec:
  template:
    metadata:
      name: additional-dbs
      labels:
        app.kubernetes.io/managed-by: {{.Release.Service | quote }}
        app.kubernetes.io/instance: {{.Release.Name | quote }}
        helm.sh/chart: "{{.Chart.Name}}-{{.Chart.Version}}"
    spec:
      restartPolicy: Never
      containers:
      - name: create-additional-dbs
        image: gkarthics/influx-additional-db:release-0.2.11
        command: ["./createdb.sh"]
        args: ["-url", "http://influxdb.default.svc:8086", "-db", "mydb1,mydb2,mydb3"]
```



### Warning:
:warning: This hook will not be executed if the pod is crashed and recreated.
