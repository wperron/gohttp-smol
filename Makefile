default: build

build:
	docker run \
	-v $(PWD):/source \
	-w /source \
	golang:1.16 \
	go build \
	-ldflags "-linkmode external -extldflags -static" \
	-a -o /source/bin/server \
	/source/main.go