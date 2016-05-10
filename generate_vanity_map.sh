#!/bin/bash

#pfad zur TXT
curl http://publish:4502/content/dam/mapfile.txt/jcr%3acontent/renditions/original -f > mapfile.txt
httxt2dbm -i mapfile.txt -o mapfile.map