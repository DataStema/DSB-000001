#!/bin/bash

#----------------------------------------------------------------------------
# This is setup, deploy and run script for 
# Data Solution Blueprint (c) serial number 000001
# Compnents:
# - CouchDB
# - PostgreSQL
# - Dremio
# - Apache Superset
#
# Glue:
# - CouchDB Exporter
#
# @company: DataStema Sarl
# @date: 10.05.2022
# @version: 1.0.0
# @author: dragos.stoica@datastema.io
#----------------------------------------------------------------------------

source .env

echo $COUCHDB_USER

# display usage and help
usage(){
	echo "Usage:"
	echo "-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~"
	echo "$0 setup"
	echo "$0 deploy"
	echo "$0 run"
    echo "$0 stop"
	echo "$0 cleanup"
	echo "-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~"
	return
}

# setup function
setup(){
#create docker folders
    if [ ! -d "./couchdb/data" ]; then
        mkdir -m 0777 -p ./couchdb/data
    fi
    if [ ! -d "./couchdb/etc" ]; then
        mkdir -m 0777 -p ./couchdb/etc
    fi
    if [ ! -d "./dremio/data" ]; then
        mkdir -m 0777 -p ./dremio/data
    fi
    if [ ! -d "./postgres/data" ]; then
        mkdir -m 0777 -p ./postgres/data
    fi
# setup CouchDB

# setup Superset
}

# deploy function
deploy(){
    echo "Deploy stage"
    echo "DONE >>> Deploy stage"
}

# clean up all folders
cleanup(){
    #delete docker folders
    echo "Cleanup stage"
    if [ -d "./couchdb" ]; then
        sudo rm -fr ./couchdb
    fi
    if [ -d "./dremio" ]; then
        sudo rm -fr ./dremio
    fi
    if [ -d "./postgres" ]; then
        sudo rm -fr ./postgres
    fi

    echo "DONE >>> Cleanup stage"
}

# run function
run(){
    echo 'CouchDB has successfuly started on http://couchdb.localhost:5894/'
    echo 'PostgreSQL has successfuly started on postgresql.localhost:5432'
    echo 'Dremio has successfuly started on http://dremio.localhost:5894/'
    echo 'Superset has successfuly started on http://couchdb.localhost:5894/'
}

# main script

# process command line parameters
if [ $# -lt 1 ]; then
	usage
	exit 0
fi
#echo $1, $2, $3, $4

case $1 in
	"setup")    setup ;;
	"cleanup")  cleanup ;;
	"deploy")   deploy ;;
	"run")      run ;;
    "stop")     stop ;;
    "usage")    usage ;;
	*)      echo "unknown command: $1"
			usage ;;
esac

exit 0

#EOF