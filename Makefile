.PHONY: up
up:
	docker compose up -d

.PHONY: stop
stop:
	docker compose stop

.PHONY: rebuild
rebuild:
	docker compose up --build -d

.PHONY: check
check:
	docker compose exec reverse_proxy nginx -t
