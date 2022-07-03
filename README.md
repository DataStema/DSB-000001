# DSB-000001
Data Solution Blueprints &copy; - Serial number 000 001

![DSB 000 001](DSB000001.png?raw=true "Data Solution Blueprint 000 001")


## Components
- CouchDB
- PostgreSQL
- Dremio
- Apache Superset

## Glue
- Couch-Export

## How to use the Data Solution Bluprints &copy;

### Prerequisites

- Linux OS. The DSB was tested on Linux Mint 20.3 Cinnamon
- Docker - version 20.10.16, you might need a Docker Hub account
- Docker-compose - version 1.25.0

## Script execution

```
./dbs.sh setup

./dbs.sh run

./dbs.sh stop

# It will erase all local data - use with caution
# This command is not reversible
./dsb.sh cleanup
```

You need to run `setup` command first in order to initialize and create the necessary setup for the Data Solution Blueprint.  
If the command is successful then execute `run` command. This will launch all containers and you should see in the console the access URLs.  
When you are done, use `stop` command. This will gracefully stop all containers.


If you want to erase all local data - this action is not reversible, and you must start all over again, run `cleanup` command.

