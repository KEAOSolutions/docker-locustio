
GITREF  = $(shell git show --oneline -s | head -n 1 | awk '{print $$1}')
VERSION = $(shell git tag | tail -n 1)


build:
	@docker build -t locustio:$(VERSION) --build-arg BUILDDATE=`date -u +%Y-%m-%dT%H:%M:%SZ` --build-arg VERSION=$(VERSION) --build-arg VCSREF=$(GITREF) .

run:
	@docker run -it --rm --name locustio_$(VERSION) --host=net -e TARGET_URL=http://172.17.0.4:8080 -e SCENARIO_FILE=/locust/movies.py -v ${PWD}:/locust locustio:$(VERSION)

build_dirty:
	@docker build -t locustio:$(VERSION)_dirty --build-arg BUILDDATE=`date -u +%Y-%m-%dT%H:%M:%SZ` --build-arg VERSION="$(VERSION)_dirty" --build-arg VCSREF="$(GITREF)" .

run_dirty:
	@docker run -it --rm --host=net --name locustio_$(VERSION)_dirty --host=net -e TARGET_URL=http://172.17.0.4:8080 -e SCENARIO_FILE=/locust/movies.py -v ${PWD}:/locust locustio:$(VERSION)_dirty

