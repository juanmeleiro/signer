#!/bin/sh

quit() {
	status=$1
	shift
	printf "\033[31m$@\033[0m\n" >&2
	exit $status
}

cleanup() {
	printf '\033[1mCleaning up...\033[0m\n'
	while test "$#" -gt 0
	do
		case "$1" in
			docker)
				docker stop signer
			;;
			keys)
				rm -r test.private.pem test.public.pem
			;;
		esac
		shift
	done
}

# 0. Verify schema
check-jsonschema --schemafile openapi.json api.json

# 1. Prepare environment
printf '\033[1mPREPARATION\033[0m\n'

printf '\033[1mCreating image...\033[0m\n'
docker build . -t signer || quit 1 "Couldn't build image."

printf '\033[1mCreating keys...\033[0m\n'
openssl ecparam -genkey -name secp521r1 -noout -out test.private.pem || {
	cleanup docker
	quit 1 "Couldn't generate private key."
}
openssl ec -in test.private.pem -pubout -out test.public.pem || {
	cleanup docker keys
	quit 1 "Couldn't generate public key."
}

# 2. Run the image in a container with some open port..
printf '\033[1mRunning container...\033[0m\n'
docker rm signer
docker run -d --name signer -p 8080:8080 -v "$PWD/test.private.pem:/app/private.pem:ro" signer || {
	cleanup docker keys
	quit 1 "Couldn't start container."
}

sleep 10

# ----------------------------------------
# Do tests
# 3. Generate a random JSON object according to some reasonable distribution.
printf '\033[1mRunning tests...\033[0m\n'

./cats -c api.json -s http://localhost:8080
# 4. Perform the tests as described in [the specification](spec.md) against the open port.

# 5. Repeat from 2 for a sufficiently large number of times.

# 6. Return a successful status if all tests failed, else report which ones failed.
# ----------------------------------------

# 7. Clean up
cleanup docker keys
