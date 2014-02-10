# Docker continuous integration workflow

This repository is demo codes for Docker continuous integration workflow.

slideshare: http://www.slideshare.net/techblogyahoo/140212-docker-continuousintegration

## Requirements

- [Vagrant](http://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)

## How to use

```
% vagrant plugin install --plugin-source https://rubygems.org/ --plugin-prerelease vagrant-vbguest
% git clone https://github.com/ydnjp/docker-continuous-integration-workflow.git; cd docker-continuous-integration-workflow
% vagrant up
```

1. Open http://localhost:8080/ (Jenkins Service)
2. See job configurations and start jobs

## Workflow

1. Build Dockerfiles.
2. Run specs with serverspec.
3. Push Docker images to private docker registry.

## Copyright

Copyright (c) 2014 Yahoo Japan Corporation. See LICENSE for further details.
