#!/bin/sh -e

cat /etc/prometheus/prometheus.yml > /tmp/prometheus.yml

#JOBS=mongo-exporter:9111 redis-exporter:9112

if [ ${JOBS+x} ]; then

for job in $JOBS
do
  echo "adding job $job"

  params_job=$(echo "${job}" | sed -r 's/(.*):([[:digit:]]+)((\/.*)*)$/\1 \2 \3/' )

  SERVICE=$(echo "${params_job}" | cut -d" " -f1)
  PORT=$(echo "${params_job}" | cut -d" " -f2)
  METRIC_PATH=$(echo "${params_job}" | cut -d" " -f3)

cat >>/tmp/prometheus.yml <<EOF

  - job_name: '${SERVICE}'
    metrics_path: '${METRIC_PATH:-/metrics}'
    dns_sd_configs:
    - names:
      - 'tasks.${SERVICE}'
      type: 'A'
      port: ${PORT}
EOF

done

fi

echo "Adding rules file"
echo "rule_files:" >> /tmp/prometheus.yml

for f in /etc/prometheus/*.rules.yml
do
  if [ -e "${f}" ]
  then
    filename=$( basename "${f}" )
    echo "- ${filename}"
    echo '  - "${filename}"' >> /tmp/prometheus.yml
  fi
done

mv /tmp/prometheus.yml /etc/prometheus/prometheus.yml

set -- /bin/prometheus "$@"

exec "$@"

