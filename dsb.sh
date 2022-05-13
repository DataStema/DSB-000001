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
# @version: 2.0.0
# @author: dragos.stoica@datastema.io
#----------------------------------------------------------------------------

source .env

# display usage and help
usage(){
    local __usage="Usage:
    -~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~
    $0 setup
        setup each container
    $0 deploy
        deploy any configuration before run
    $0 run
        main execution loops, launch Data Solution Blueprint
    $0 stop
        stop execution loop
    $0 cleanup
        clean all folders and data
    -~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~"
    echo -e "$__usage"
	return
}

# setup function
setup(){
    echo "Setup stage"
    #create docker folders
    local FOLDERS=( "./couchdb" "./couchdb/data" "./couchdb/etc" "./dremio" "./dremio/data" "./postgres" "./postgres/data" )
    for i in "${FOLDERS[@]}"
    do
	    if [ ! -d "$i" ]; then
        mkdir -m 0777 -p $i
        fi
    done

    # setup CouchDB
    docker-compose up -d couchdb superset
    COUCH_URL=http://$COUCHDB_USER:$COUCHDB_PASSWORD@couchdb.localhost:5984
    sleep 10

    curl -X PUT $COUCH_URL/_users
    curl -X PUT $COUCH_URL/_replicator
    curl -X PUT $COUCH_URL/_global_changes

    # setup Superset
    docker exec -it superset-dremio superset fab create-admin \
                --username $SUPERSET_USER \
                --firstname DataStema \
                --lastname Admin \
                --email contact@datastema.io \
                --password $SUPERSET_PASSWORD
    docker exec -it superset-dremio superset db upgrade
    # This step is optional - it populates Apache Superset with examples
    #docker exec -it superset-dremio superset load_examples
    docker exec -it superset-dremio superset init
    
    sleep 10
    docker-compose stop couchdb superset
    echo "DONE >>> Setup stage"
}

# deploy function
deploy(){
    echo "Deploy stage"
    echo "DONE >>> Deploy stage"
}

# clean up all folders
cleanup(){
    echo "Cleanup stage"
    #delete docker folders
    local FOLDERS=("./couchdb" "./dremio" "./postgres")
    for i in "${FOLDERS[@]}"
    do
	    if [ -d "$i" ]; then
            sudo rm -fr $i
        fi
    done

    echo "DONE >>> Cleanup stage"
}

# run function
run(){
    echo "Run stage"
    docker-compose up -d

    echo "CouchDB has successfuly started on http://couchdb.localhost:5984/_utils"
    echo "        user: $COUCHDB_USER | password: $COUCHDB_PASSWORD"
    echo "PostgreSQL has successfuly started on postgresql.localhost:5432"
    echo "        user: $POSTGRES_USER | password: $POSTGRES_PASSWORD"
    echo "Dremio has successfuly started on http://dremio.localhost:9047/"
    echo "        create your own user"
    echo "Superset has successfuly started on http://supersetdremio.localhost:8088/"
    echo "        user: $SUPERSET_USER | password: $SUPERSET_PASSWORD"
    echo -e "\n\nDONE >>> Run stage"
}

# stop function
stop(){
    echo "Stop stage"
    docker-compose stop
    echo "DONE >>> Stop stage"
}

##############################################################################
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

# end of main script
##############################################################################