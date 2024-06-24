# Title

Description

## Setup

### Clone the repository

`git clone https://github.com/SebaxFentex/airflow`

### Create the extended airflow image

`docker build . -t "image_name:version"`

### Edit docker-compose.yaml and set your image_name and version

```bash
x-airflow-common:
  &airflow-common
  image: ${AIRFLOW_IMAGE_NAME:-image_name:version}
```

### Init Airflow

`docker compose run airflow-init`

### Run

`docker compose up -d`

### Open Airflow Webserver

http://localhost:8080