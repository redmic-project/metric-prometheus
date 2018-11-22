FROM prom/prometheus

COPY conf /etc/prometheus/

ENTRYPOINT [ "/etc/prometheus/docker-entrypoint.sh" ]
CMD [ "--config.file=/etc/prometheus/prometheus.yml", \
	"--storage.tsdb.path=/prometheus", \
	"--web.console.libraries=/etc/prometheus/console_libraries", \
	"--web.console.templates=/etc/prometheus/consoles" ]
