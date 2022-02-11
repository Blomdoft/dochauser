FROM ubuntu:latest


RUN groupadd -g 1002 elasticsearch \
        && useradd -rm -d /home/elasticsearch -s /bin/bash -g 1002 -u 1002 elasticsearch \
        && groupadd -g 1001 scanner \
        && useradd -rm -d /home/scanner -s /bin/bash -g 1001 -u 1001 scanner

RUN apt-get update \
        && apt-get install -y wget \
	&& apt-get install -y gnupg2 \
        && wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - \
        && echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list \
        && apt-get update \
        && apt-get install -y curl \
        && apt-get install -y uuid\
        && apt-get install -y uuid-runtime \
	&& apt-get install -y ocrmypdf \
	&& apt-get install -y tesseract-ocr-deu \
	&& apt-get install -y imagemagick \
	&& apt-get install -y cron \
        && apt-get install -y apt-transport-https \
        && apt-get install -y elasticsearch \
        && apt-get install -y openjdk-17-jre-headless

RUN update-rc.d elasticsearch defaults 95 10
 
WORKDIR /home/scanner

COPY --chown=scanner:scanner . .

RUN wget https://github.com/AsamK/signal-cli/releases/download/v0.10.3/signal-cli-0.10.3-Linux.tar.gz \
    && tar -xvf signal-cli-0.10.3-Linux.tar.gz -C apps \
    && mkdir -p .local/share \
    && tar -xvf signal-cli.tar -C .local/share \
    && chown -R scanner:scanner .local

VOLUME /home/scanner/archive
VOLUME /home/scanner/scanner


EXPOSE 9200

RUN crontab -l | { cat; echo "* * * * * timeout 1h flock -n /home/scanner/apps/lock/translateNewFiles.lock su scanner -c /home/scanner/apps/scripts/translateNewFiles.sh"; } | crontab -
CMD /home/scanner/apps/scripts/startupServices.sh && cron -f



