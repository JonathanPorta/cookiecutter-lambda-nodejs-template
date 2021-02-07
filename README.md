# [Cookiecutter](https://cookiecutter.readthedocs.io/) Template for Lambda+NodeJS Projects

_deploys via Terraform_

# What does it do?

This will do nothing for you unless you have Cookiecutter's CLI or a willingness to run some commands.

# Deps

You need a recent version of Node.JS, NPM installed, and something to sip on.

```
git clone git clone git@github.com:JonathanPorta/cookiecutter-lambda-nodejs-template.git
pip install --user cookiecutter
```

# Usage

```
cookiecutter ./cookiecutter-lambda-nodejs-template
```

# Todo Notes

- Copy non template files

- Loop and create multiple sets of something - (maybe a sub cookie cutter config? then merge the files into the same directory in an after generation hook)
- Add in git sub tree:

```
  - `$ git remote add ops git@github.com:jonathanporta/ops.git --no-tags`
  - `$ git subtree add --prefix ops/ ops master --squash`

```
