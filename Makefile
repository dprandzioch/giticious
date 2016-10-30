docker:
	docker run -it --rm -v ${PWD}:/app -w /app centos/ruby-22-centos7 /bin/bash

build:
	gem build giticious.gemspec

release: build
	gem push giticious-*.gem
