FROM ubuntu:latest
RUN apt-get update \
	&& apt-get install -y ocrmypdf \
	&& apt-get install tesseract-ocr-deu \
	&& apt-get install -y imagemagick \
	&& apt-get install -y cron

WORKDIR /scanner
COPY . .
VOLUME /scanner/archive
VOLUME /scanner/scanner
RUN crontab -l | { cat; echo "* * * * * timeout 1h flock -n /scanner/apps/lock/translateNewFiles.lock /scanner/apps/scripts/translateNewFiles.sh"; } | crontab -
CMD ["cron", "-f"]



