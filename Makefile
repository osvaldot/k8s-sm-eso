build-cli:
	docker build -t "$$(printf '%s/terraform-cli' "$${PWD##*/}" | tr -d .):1.0.10" .

cli:
	@touch .env || true
	@docker run --rm -it --workdir /app \
	--entrypoint bash -v $${PWD}:/app \
	--env-file .env \
	"$$(printf '%s/terraform-cli' "$${PWD##*/}" | tr -d .):1.0.10"		