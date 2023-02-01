#/usr/bin/env bash

# Cordon a node

unset HISTFILE

kubectl drain $(hostname)