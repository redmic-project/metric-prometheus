#!/bin/sh

rulesPath=${PROMTOOL_RULES_PATH:-deploy/rules}
imageName=${PROMTOOL_IMAGE_NAME:-dnanexus/promtool}
imageTag=${PROMTOOL_IMAGE_TAG:-2.9.2}

checkOutput=0

for f in "$(pwd)"/deploy/rules/*.yml
do
	if [ -e "${f}" ]
	then
		filename=$(basename "${f}")

		if ! docker run --rm \
			-v "$(pwd)/${rulesPath}:/mnt" \
			"${imageName}:${imageTag}" \
				check rules "/mnt/${filename}"
		then
			checkOutput=1
			echo ""
		fi
	fi
done

exit "${checkOutput}"
