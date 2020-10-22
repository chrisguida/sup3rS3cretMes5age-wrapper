ASSETS := $(shell yq r manifest.yaml assets.*.src)
ASSET_PATHS := $(addprefix assets/,$(ASSETS))
VERSION_TAG := $(shell git --git-dir=sup3rS3cretMes5age/.git describe --abbrev=0 --tags)
VERSION := $(VERSION_TAG:v%=%)
SSM_SRC := $(shell find sup3rS3cretMes5age -name '*.go') $(shell find sup3rS3cretMes5age -name 'go.*')
SSM_FRONTEND_SRC := $(shell find sup3rS3cretMes5age/frontend/ -type d \( -path sup3rS3cretMes5age/frontend/dist -o -path sup3rS3cretMes5age/frontend/node_modules \) -prune -o -name '*' -print)
SSM_GIT_REF := $(shell cat .git/modules/sup3rS3cretMes5age/HEAD)
SSM_GIT_FILE := $(addprefix .git/modules/sup3rS3cretMes5age/,$(if $(filter ref:%,$(SSM_GIT_REF)),$(lastword $(SSM_GIT_REF)),HEAD))

.DELETE_ON_ERROR:

all: supersecretmessage.s9pk

install: supersecretmessage.s9pk
	appmgr install supersecretmessage.s9pk

supersecretmessage.s9pk: manifest.yaml config_spec.yaml config_rules.yaml image.tar instructions.md $(ASSET_PATHS)
	appmgr -vv pack $(shell pwd) -o supersecretmessage.s9pk
	appmgr -vv verify supersecretmessage.s9pk

image.tar: Dockerfile docker_entrypoint.sh httpd.conf $(SSM_SRC) sup3rS3cretMes5age/frontend/dist
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --tag start9/sup3rS3cretMes5age --platform=linux/arm/v7 -o type=docker,dest=image.tar .

httpd.conf: manifest.yaml httpd.conf.template
	tiny-tmpl manifest.yaml < httpd.conf.template > httpd.conf

sup3rS3cretMes5age/frontend/dist: $(SSM_FRONTEND_SRC) sup3rS3cretMes5age/frontend/node_modules
	npm --prefix sup3rS3cretMes5age/frontend run build

sup3rS3cretMes5age/frontend/node_modules: sup3rS3cretMes5age/frontend/package.json sup3rS3cretMes5age/frontend/package-lock.json
	npm --prefix sup3rS3cretMes5age/frontend install

manifest.yaml: $(SSM_GIT_FILE)
	yq w -i manifest.yaml version $(VERSION)
	yq w -i manifest.yaml release-notes https://github.com/algolia/sup3rS3cretMes5age/releases/tag/$(VERSION_TAG)
