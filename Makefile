setup:
	mix deps.get
	docker run --name postgres -e POSTGRES_PASSWORD=postgres -d postgres
	mix ecto.create