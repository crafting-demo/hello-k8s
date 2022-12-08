# Crafting Kubernetes Development Demo

This is a minimal app for demonstrating the Kubernetes Development support
from the Crafting Sandbox system.

## The App

This is a simplest 2-tier app:

- A frontend serving HTTP for web pages and restful APIs;
- A backend handling the _hello_ logic.

## The Flows

### Pipeline

Creating a PR or merging to master will trigger GitHub Action to build and
push container images to a demo container registry.

Merging to master will bump the `latest` image tag.

Push a release tag (`v*`) will tag container images with release version.
This must be done after the build completes on the corresponding master branch.

### Development

Creating a Crafting Sandbox will automatically deploy the latest release to
a dedicated namespace in a development Kubernetes cluster.
After this, the workspaces in the sandbox can intercept the workload in the
cluster for development.

All processes running in the sandbox is configured with:

- Always launched with debugger
- Hot-reloading enabled

With that, VSCode debugging is configured to use `attach` mode.

#### Frontend

When in the sandbox, frontend is talking to the local backend (on `localhost`).
Most of the development can be done using the `dev` endpoint.
To directly use the backend in the cluster, set env variable:

```sh
BACKEND_URL=https://backend.${APP_NS}:8000
```

Restart the process and intercept the `frontend` deployment.


By default, there is no header propagation for the frontend app (`npm run start`). You can enable propagaton by running the below commands:

- `npm run start-otel`:  propagation via `baggage` and/or `W3C trace context` (OpenTelemetry). You can modify the `ot-tracing.js` to enable other propagators if needed. e.g. `B3` , `Jaeger` etc.

#### Backend

The backend development can be done inside the sandbox with `dev` endpoint which
talks to the local frontend process.
To work with the frontend in the cluster, intercept the `backend` deployment on
port `8000`.

### Intercept Kubernetes

The example for intercepting backend with an Ingress Endpoint (not affecting regular ingress):

```sh
cs infra k8s intercept start -n $APP_NS -R deploy/$APP_NS/backend:app:8000:8000 --ingress svc/$APP_NS/frontend
```
