# Signer microservice

This repo contains all that's needed to generate and test an image for a microservice that signs JSON objects into a JWT.

## Interface

You can generate an image by using the typical `docker build .`. The image expects to be run in a container with an open port `8080` and a private key in PEM format mounted as a file in `/app/private.pem`. Check the commands in `test.sh` that generate test keys for more details.

For running tests, it is expected that you have the binary for the [Cats fuzzer](https://endava.github.io/cats/) in the root directory, the Docker daemon running, and `check-jsonschema` installed in your machine (e.g., in Alpine the package is also called `check-jsonschema`). Then, just run the `test.sh` script.
