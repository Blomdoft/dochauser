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
        && apt-get install -y openjdk-17-jre-headless \
        && apt-get install -y poppler-utils \
        && apt-get install -y rclone \
        && apt-get install -y jq 

RUN update-rc.d elasticsearch defaults 95 10
 
WORKDIR /home/scanner

COPY --chown=scanner:scanner . .

# change imagemagic config
ARG imagemagic_config=/etc/ImageMagick-6/policy.xml
RUN if [ -f $imagemagic_config ] ; then sed -i 's/<policy domain="coder" rights="none" pattern="PDF" \/>/<policy domain="coder" rights="read|write" pattern="PDF" \/>/g' $imagemagic_config ; else echo did not see file $imagemagic_config ; fi

# Volumes for mounts
VOLUME /home/scanner/archive
VOLUME /home/scanner/scanner

EXPOSE 9200

RUN printf "http.host: 0.0.0.0\nnetwork.host: 0.0.0.0\ndiscovery.type: single-node\n" >> /etc/elasticsearch/elasticsearch.yml
 
RUN crontab -l | { cat; echo "* * * * * timeout 1h flock -n /home/scanner/apps/lock/translateNewFiles.lock su scanner -c /home/scanner/apps/scripts/translateNewFiles.sh"; } | crontab -
RUN crontab -l | { cat; echo "* * * * * timeout 1h flock -n /home/scanner/apps/lock/translateUploadedFiles.lock su scanner -c /home/scanner/apps/scripts/translateUploadedFiles.sh"; } | crontab -
RUN crontab -l | { cat; echo "*/5 * * * * timeout 1h flock -n /home/scanner/apps/lock/syncCloud.lock su scanner -c /home/scanner/apps/scripts/syncCloud.sh"; } | crontab -
RUN crontab -l | { cat; echo "0 0 * * 0 timeout 1h flock -n /home/scanner/apps/lock/backupElasticSearchIndex.lock su scanner -c /home/scanner/apps/scripts/backupElasticSearchIndex.sh"; } | crontab -
RUN crontab -l | { cat; echo "*/5 * * * * timeout 1h flock -n /home/scanner/apps/lock/analyzeWithGpt.lock su scanner -c /home/scanner/apps/scripts/analyzeWithGpt.sh"; } | crontab -
RUN crontab -l | { cat; echo "*/5 * * * * timeout 1h flock -n /home/scanner/apps/lock/copyToStructureAnalyzed.lock su scanner -c /home/scanner/apps/scripts/copyToStructureAnalyzed.sh"; } | crontab -
RUN crontab -l | { cat; echo "0 0 * * 0 timeout 1h flock -n /home/scanner/apps/lock/houseKeeping.lock su scanner -c /home/scanner/apps/scripts/houseKeeping.sh"; } | crontab -

CMD /home/scanner/apps/scripts/startupServices.sh && cron -f



