#/usr/bin/env bash

# Must be run on master node

# chmod break kubectl and chmod

unset HISTFILE

sudo chmod -x $(which kubectl)
sudo chmod -x $(which chmod)