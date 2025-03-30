.PHONY: up
up:
	docker compose up -d

.PHONY: stop
stop:
	docker compose stop

.PHONY: reload
reload:
	docker compose exec reverse_proxy nginx -s reload
