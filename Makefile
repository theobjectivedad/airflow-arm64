TAG:=theobjectivedad/airflow-arm64:latest
VERSION:=theobjectivedad/airflow-arm64:1.10.15-100

build:
	docker build . -t $(TAG)

push:
	docker push $(TAG)

cli:
	docker run -it --rm --entrypoint /bin/bash -v $(CURDIR):/mnt/local $(TAG)

push:
	docker tag $(TAG) $(VERSION)
	docker push $(VERSION)
