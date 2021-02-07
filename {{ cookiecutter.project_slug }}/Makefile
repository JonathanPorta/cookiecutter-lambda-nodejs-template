APP_NAME={{ cookiecutter.project_slug }}
CWD=$(shell pwd)

include ops/common.mk

deps:: common_jq_binary download_ca_certs
	-mkdir -p ./build
	yarn install

download_ca_certs:
	@echo 'Grabbing CA and Intermediary certificates.'
	@echo 'Downloading CA Certificates bundle from https://curl.haxx.se/ca/cacert.pem...'
	@curl -s -L https://curl.haxx.se/ca/cacert.pem -o ca-certificates.crt > /dev/null
	@echo 'Done.'
	@echo 'Downloading LE Intermediary Certificate from https://letsencrypt.org/certs/letsencryptauthorityx3.pem.txt...'
	@curl -s -L https://letsencrypt.org/certs/letsencryptauthorityx3.pem.txt >> ./ca-certificates.crt
	@echo 'Done.'
	@echo 'Downloading LE Intermediary Certificate from https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem.txt...'
	@curl -s -L https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem.txt >> ./ca-certificates.crt
	@echo 'Done.'

package:
	cd ./build && zip -r9 ../${APP_NAME}.zip *

release: aws_lambda_deploy

clean::
	-rm ca-certificates.crt
	-rm ${APP_NAME}.zip
	-rm -rf build
	-rm -rf tmp
	-rm -rf .terraform
	-rm -rf node_modules

test:
	@echo 'TODO: Actually test something, dude.'

build: clean deps
	cp ./ca-certificates.crt ./build/
	cp ./*.js ./build
	cp ./*.json ./build
	cp -r ./node_modules ./build
