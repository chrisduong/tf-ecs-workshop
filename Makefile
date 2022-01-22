LINUX_FLAGS = CGO_ENABLED=0 GOOS=linux GOARCH=amd64
LINUX_LDFLAGS = -ldflags '-X main.Version=${VERSION}' -o ../outputs/http-server_linux

MACOS_FLAGS = CGO_ENABLED=0 GOOS=darwin GOARCH=arm64
MACOS_LDFLAGS = CGO_ENABLED=0 GOOS=darwin GOARCH=arm64

SEMVER = $(subst v,,${VERSION})

build:
	cd http-server; \
	${LINUX_FLAGS} go build ${LINUX_LDFLAGS} .
.PHONY: build

build_macos:
	cd http-server; \
	${MACOS_FLAGS} go build ${MACOS_LDFLAGS} .
.PHONY: build_macos

docker:
	docker build -t http-server:${SEMVER} .
