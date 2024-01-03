fmt:
	@scarb fmt 

clean:
	@scarb clean

build: clean
	@scarb build

deploy: build
	@./scripts/deploy.sh