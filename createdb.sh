#!/bin/bash
# Reading the databases o be created, separated by comma
INFLUX_URL=""
DB_NAMES=""

while [ $# -gt 0 ]
do
	case "$1" in
		-url) INFLUX_URL="$2" ;  shift ;;
		-db) DB_NAMES="$2" ; shift ;;
		--) shift; break ;;
		*) break ;;
	esac
	shift
done

# Validating the URL and DB names inputs
if [ -z "$INFLUX_URL" ]
then
  echo "InfluxDB should be passed like:  -url http://localhost:8086 "
  exit 1
fi

if [ -z "$DB_NAMES" ]
then
  echo "Comma separated DB names should be passed like:  -db mybd1,mydb2 "
  exit 1
fi

echo "Server address: $INFLUX_URL"

# Variables
success_code=204
try_again=1


set -f
DB_NAME=(${DB_NAMES//,/ })

NUM_VARS=${#DB_NAME[@]}

if [ $NUM_VARS -lt 1 ]; then
	echo "No database to instantiate";
	exit 0;
else
	echo "Total DBs to be created: ${NUM_VARS}"
fi




# Check for the availability of the Database and keeps pinging once in 3s till it is up
check_database_readiness() {
	# ready_check command to check the database is up or not yet
	ready_check="curl -sL -I --write-out "%{http_code}" --silent --output /dev/null $INFLUX_URL/ping"

	while [ $try_again -eq 1 ]
	do
		if [ "$(eval $ready_check)" -eq "$success_code" ];then
		  echo "Database is ready to accept connections";
		  try_again=0
		else
		  echo "Database not ready yet!";
		  sleep 3s;
		fi
	done
}

# Creating databases in InfluxDB
create_database() {
	echo "Total databases to be created: ${NUM_VARS}"

	while [ -n "${DB_NAME[i]}" ]
	do
	  echo "Creating database: ${DB_NAME[i]} "
	  curlCmd="curl -XPOST --write-out "%{http_code}" --silent --output /dev/null $INFLUX_URL/query --data-urlencode 'q=create database ${DB_NAME[i]}'"
	  status_code= eval $curlCmd
	  echo $status_code
	  (( i = i + 1 ))
	  sleep 1s
	done

	echo "Total created databases:  ${NUM_VARS}"
}

check_database_readiness

if [ $try_again -eq 0 ]; then
	create_database
fi