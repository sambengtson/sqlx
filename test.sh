docker compose up -d
export SQLX_POSTGRES_DSN="postgres://postgres:postgres@localhost:5432/sqlxtest?sslmode=disable"
export SQLX_MYSQL_DSN="sqlx:sqlx@tcp(localhost:3306)/sqlxtest?parseTime=true"
export SQLX_SQLITE_DSN=":memory:"
go test ./...
docker compose down
