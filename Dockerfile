FROM ubuntu:latest
RUN apt-get update \
	&& apt-get install -y ocrmypdf \
	&& apt-get install tesseract-ocr-deu \
	&& apt-get install -y imagemagick \
	&& apt-get install -y cron
RUN groupadd -g 1001 scanner \
        && useradd -rm -d /home/scanner -s /bin/bash -g 1001 -u 1001 scanner
WORKDIR /home/scanner
COPY --chown=scanner:scanner . .
VOLUME /home/scanner/archive
VOLUME /home/scanner/scanner
RUN crontab -l | { cat; echo "* * * * * timeout 1h flock -n /home/scanner/apps/lock/translateNewFiles.lock su scanner -c /home/scanner/apps/scripts/translateNewFiles.sh"; } | crontab -
CMD ["cron", "-f"]



