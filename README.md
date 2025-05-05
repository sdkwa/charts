# sdkwa Helm Charts
[![Artifact HUB](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/artifact-hub)](https://artifacthub.io/packages/helm/sdkwa/sdkwa)

This repository contains helm charts for [sdkwa](https://github.com/sdkwa/charts).

Before installation need to generate and install secret file to your k8s cluster. See the [docker-secrets-example](./docker-secrets-example.yaml)

## Installation
```bash
helm repo add sdkwa https://sdkwa.github.io/charts
helm install sdkwa sdkwa/sdkwa
```

## Configuration
Check the [README.md](./charts/sdkwa/README.md)

## Questions? Feedback?
[Join our discord server.](https://discord.gg/cJXdrwS)
