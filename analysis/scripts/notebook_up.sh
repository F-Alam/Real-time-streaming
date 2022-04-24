#!/bin/bash
# This file contains a script that brings up a jupyter notebook. It searches and prints the external IP of the VM and
# the prints the notebook command output (which has a URL to connect to that needs the external IP to filled in).
# ** Please note, it does not run in the backbround and that with ssh port forwarding the external IP is not required.**
#
echo "Creating jupyter notebook - this script will run in the foreground because we need to get the token"
# run jupyter notebook on spark container
#
docker-compose exec spark pip install pyhive >& /dev/null

docker-compose exec spark env PYSPARK_DRIVER_PYTHON=jupyter PYSPARK_DRIVER_PYTHON_OPTS='notebook --no-browser --port 8888 --ip 0.0.0.0 --allow-root --notebook-dir=/w205/' pyspark


