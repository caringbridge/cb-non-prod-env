#!/bin/bash

env_ver=$(awk -F"[/']"" '/ env_ver/ {print $2}' Vagrantfile)

echo  "Starting environement: $env_ver"

vagrant up cfgsvr-$env_ver && vagrant up s1-$env_ver && vagrant provision s1-$env_ver && vagrant up s2-$env_ver && vagrant provision s2-$env_ver && vagrant up zend-$env_ver
