# Where the whole structure is resident
#BASE=/Users/florian/Documents/dochauser_mount
BASE=/home/scanner

# All outputs are stored below this directory
ARCHIVE_DIR=$BASE/archive/

# Where all inputs are to be found
MONITOR_DIR=$BASE/scanner/
IMPORT_DIR=$BASE/import/

CATEGORIZED_DIR=$BASE/archive/categorized/
ES_BACKUP_DIR=$BASE/archive/es_backup
RCLONE_CONFIG=$BASE/apps/config/rclone.conf
LOG_FILE=$BASE/apps/log/dochauser.log

# Signal functionality currently does not exist
SIGNAL_NUMBER=+41445008346
SIGNAL_DIR=$BASE/apps/signal-cli-0.10.3/bin/
SIGNAL_GROUP=dZRhXx+fbwTl9QBkPGWeBkHh4UFtOio5suJZQyQ1O0Y=

#Elastic search server (in same container, should be localhost on server)
ES_HOST="localhost"

