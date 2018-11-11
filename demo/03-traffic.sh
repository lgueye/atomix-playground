#!/usr/bin/env bash

cd ../traffic

time mvn clean install && java -jar target/traffic*.jar

cd -
