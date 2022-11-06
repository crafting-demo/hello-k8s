# Crafting Kubernetes Development Demo

This is a minimal app for demonstrating the Kubernetes Development support
from the Crafting Sandbox system.

## The App

This is a simplest 2-tie app:

- A frontend serving HTTP for web pages and restful APIs;
- A backend handling the _hello_ logic.

## The Flows

### Pipeline

Creating a PR or merging to master will trigger GitHub Action to build and
push container images to a demo container registry.
Merging to master will also update the demo Kubernetes cluster with latest
version.

### Development

Creating a Crafting Sandbox will automatically deploy the latest release to
a dedicated namespace in a development Kubernetes cluster.
After this, the workspaces in the sandbox can intercept the workload in the
cluster for development.
