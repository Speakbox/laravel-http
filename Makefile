build:
	docker build -t speakbox/laravel-http:latest .

run:
	docker run -ti -p 80:80 speakbox/laravel-http:latest /bin/sh
