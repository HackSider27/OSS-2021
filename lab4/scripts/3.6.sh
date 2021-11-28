#!/bin/bash

A=`echo -e "$USER$HOME" | tr -d "\n" | wc -c`

echo "$USER $HOME $A"
