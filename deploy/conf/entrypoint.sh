#!/bin/sh -e

cat ${CONFIG_PATH}/${INITIAL_CONFIG_FILENAME} > /tmp/prometheus.yml

if [ ${JOBS:+x} ]
then
	for job in $(echo "${JOBS}" | tr ',' ' ')
	do
		echo "adding job ${job}"

		jobParams=$(echo "${job}" | sed -r 's/(.*):([[:digit:]]+)(\/[^;]*)?(;([[:digit:]]+)?)?(;([[:digit:]]+)?)?$/\1 \2 \3 \5 \7/')

		serviceName=$(echo "${jobParams}" | cut -d " " -f1)
		port=$(echo "${jobParams}" | cut -d " " -f2)
		metricsPath=$(echo "${jobParams}" | cut -d " " -f3)
		scrapeInterval=$(echo "${jobParams}" | cut -d " " -f4)
		scrapeTimeout=$(echo "${jobParams}" | cut -d " " -f5)

		cat >>/tmp/prometheus.yml <<EOF

  - job_name: '${serviceName}'
    ${scrapeInterval:+scrape_interval: ${scrapeInterval}s}
    ${scrapeTimeout:+scrape_timeout: ${scrapeTimeout}s}
    ${metricsPath:+metrics_path: '${metricsPath}'}
    dns_sd_configs:
      - names:
          - 'tasks.${serviceName}'
        type: 'A'
        port: ${port}
EOF
	done
fi

if ls ${CONFIG_PATH}/*.rules.yml > /dev/null 2> /dev/null
then
	echo "Adding rules file"
	echo "rule_files:" >> /tmp/prometheus.yml

	for f in ${CONFIG_PATH}/*.rules.yml
	do
		if [ -e "${f}" ]
		then
			filename=$( basename "${f}" )
			echo "adding rules ${filename}"
			echo '  - "'${filename}'"' >> /tmp/prometheus.yml
		fi
	done
fi

mv /tmp/prometheus.yml ${CONFIG_PATH}/${FINAL_CONFIG_FILENAME}

set -- /bin/prometheus "$@"

exec "$@"
