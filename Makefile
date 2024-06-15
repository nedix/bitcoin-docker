setup:
	@test -e .env || cp .env.example .env
	@docker build . -t bitcoin

up: port = 8332
up:
	@docker run --rm --name bitcoin \
        --env-file .env \
        -p 127.0.0.1:$(port):8332 \
        bitcoin

down:
	-@docker stop bitcoin

shell:
	@docker exec -it bitcoin /bin/sh
