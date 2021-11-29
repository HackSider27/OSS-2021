#!/bin/bash

ps -eo "%U%u%c" | tail -n +2 | awk '{if ($1 != $2) print $3}'
