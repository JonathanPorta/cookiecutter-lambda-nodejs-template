# {{ cookiecutter.project_slug }} - _the world's leading nodejs lambda function_

Scaffolded via [cookiecutter-lambda-nodejs-template](https://github.com/JonathanPorta/cookiecutter-lambda-nodejs-template).

# Dependencies

Please ensure you have the following:

0. aws-cli installed or aws credentials set in .env
1. a recent version of nodejs
2. make

# Usage

```
source .env && make build package
```

## Testing

The mocks directory contains sample events in JSON format.

```
make test
```

## Deploy

```
source .env
```

Build and create the lambda package. Then deploy to lambda. Uses terraform behind the scenes.

```
make build package
make release
```
