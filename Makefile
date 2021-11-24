include .env

build-cli:
	docker build -t "$$(printf '%s/terraform-cli' "$${PWD##*/}" | tr -d .):${TERRAFORM_VERSION}" \
		--build-arg TERRAFORM_VERSION=${TERRAFORM_VERSION} \
		--build-arg KUBECTL_VERSION=${KUBECTL_VERSION} \
		.

cli:
	@touch .env || true
	@docker run --rm -it --workdir /app \
	--entrypoint bash -v $${PWD}:/app \
	--env-file .env \
	"$$(printf '%s/terraform-cli' "$${PWD##*/}" | tr -d .):${TERRAFORM_VERSION}"		