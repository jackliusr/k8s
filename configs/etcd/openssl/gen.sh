#!/usr/bin/env bash

openssl req -newkey rsa:2048 -nodes -keyout server.key \
 -extensions v3_ext -extfile server.conf \
  -x509 -out [filepath to cert]