#!/bin/sh

for f in $(pwd)/deploy/rules/*.rules.yml
do
	if [ -e "$f" ]
	then
		filename=$( basename "$f" )
		docker run -v $(pwd)/deploy/rules/:/tmp dnanexus/promtool:1.0 \
			check rules /tmp/${filename}
	fi
done