postgres:
	docker run --name postgres-bank -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:15.4-alpine

createdb:
	docker exec -it postgres-bank createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres-bank dropdb simple_bank

migratedown:
	migrate -path db/migration -database="postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down
migrateup:
	migrate -path db/migration -database="postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

CURRENT_DIR := $(shell cd)

sqlc:
	docker run --rm -v "$(CURRENT_DIR)":/src -w /src sqlc/sqlc generate

test:
	go test -v -cover ./...


.PHONEY: postgres createdb dropdb migrateup migratedown sqlc test
