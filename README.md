# Prometheus

## Adding services dynamically

Set `JOBS` environment variable with a string of service scrape definitions, separated by `,`.

Single scrape definition follow this syntax:

```sh
<serviceName>:<port>[<metricsPath>][;[<scrapeInterval>][;[<scrapeTimeout>]]]
```

Each service scrape definition can contains 5 parameters (**bold** ones are mandatory):

* **serviceName**: Used as scrape job name and hostname (with `tasks.` prefix) of service to scrape.
* **port**: The service port to scrape metrics from.
* metricsPath: The HTTP resource path on which to fetch metrics from target. Default is `/metrics`.
* scrapeInterval: How frequently to scrape target. Default is `15s`.
* scrapeTimeout: Per-scrape timeout when scraping target. Default is `10s`.

### Example

Consider 3 services to scrape:

```sh
JOBS=service1:8080,service2:8000/metrics-path;60;30,service3:3000;;20
```

* `service1` uses port `8080` (other params use default values).
* `service2` uses port `8000`, path `/metrics-path`, interval `60s` and timeout `30s`.
* `service3` uses port `3000` and timeout `20s` (other params use default values).
