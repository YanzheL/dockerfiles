# By.Dark495 https://dark495.me 2021-12-24

ulimit -S -c 0

WATCHDOG_INTERVAL=60
WATCHDOG_PATH="/PCDNService"
#WATCHDOG_PATH="/mnt/e/dockerProjects/iqiyi-small"
WATCHDOG_EXE="/ipes/bin/ipes"
WATCHDOG_WATCH="ipes-agent"
WATCHDOG_LOG="${WATCHDOG_PATH}/watchdog.log"
WATCHDOG_LOG_RUN="${WATCHDOG_PATH}/run.log"
KEEP_NEWEST_VERSION="1"

function downloadLatestVersion(){
        log "INFO" "Download newest IPES file ..."
        if [ ! -d $WATCHDOG_PATH ]; then
                mkdir $WATCHDOG_PATH
        fi
        cd $WATCHDOG_PATH
        rm -rf $WATCHDOG_PATH/ipes/var/db/ipes/

        curl --connect-timeout 10 -m 240 --retry 10 -o ./newest.tar.gz https://ipes-tus.iqiyi.com/update/ipes-linux-amd64-cqgl-latest.tar.gz
        if [ $? -eq 0 ]; then
                log "SUCC" "Download Success."
        else
                log "ERR" "Download failed."
                exit 1
        fi

        tar -zxvf newest.tar.gz
}

function echoVersion(){
        ipesVersionRaw="$($WATCHDOG_PATH/ipes/bin/ipes version)"
        buildTime=$(echo "$ipesVersionRaw" | grep BuildTime)
        ipesVersion=$(echo "$ipesVersionRaw" | grep IPES)
        goVersion=$(echo "$ipesVersionRaw" | grep go)

        echo "IPES Version              : ${ipesVersion:13}"
        echo "IPES Build Time           : ${buildTime:10}"
        echo "IPES Go Version           : $goVersion"
        echo "HAPP Native Version       : $(cat $WATCHDOG_PATH/ipes/var/db/ipes/happ-native-*/bin/version)"
        echo "IPES Agent Native Version : $(cat $WATCHDOG_PATH/ipes/var/db/ipes/ipes-agent-native-*/bin/version)"
}


function service_init(){
        if [ -n $KEEP_NEWEST_VERSION ]; then
                downloadLatestVersion
        fi

                log "ERR" "HAPP_COUNT is empty or error."
                exit
        fi

        log "INFO" "Write data path ..."

    mkdir -p $WATCHDOG_PATH/ipes/var/db/ipes/happ-conf
    echo "args:" > $WATCHDOG_PATH/ipes/var/db/ipes/happ-conf/custom.yml

        for(( i = 1; i <= $HAPP_COUNT; i = i + 1)); do
                mkdir -p /data/happ${i}
        echo "  - '/data/happ${i}'" >> $WATCHDOG_PATH/ipes/var/db/ipes/happ-conf/custom.yml
    done

        log "INFO" "Service Init Success ."
}

function watchdog_start() {
    chmod +x $WATCHDOG_PATH$WATCHDOG_EXE
    $WATCHDOG_PATH$WATCHDOG_EXE $1 $2 > $WATCHDOG_LOG_RUN  2>&1 &
        log "INFO" "start $WATCHDOG_PATH$WATCHDOG_EXE"
}

function watchdog_stop() {
    killall -9 $WATCHDOG_PATH$WATCHDOG_EXE >/dev/null 2>&1
        log "INFO" "kill $WATCHDOG_EXE"
}

function watchdog_init() {
        touch $WATCHDOG_LOG
        while [ 0 -lt 1 ]; do
                if [ $(ps -ef | grep 'ipes start -w' | grep -v 'grep' | wc -l) -ge 1 ]; then
                 log "INFO" "status = OK." 1
                else
                 log "WARN" "$WATCHDOG_EXE is not running"
                 sleep 3
                 watchdog_start start
                fi

                sleep $WATCHDOG_INTERVAL
        done
}

function log(){
        t="`date '+%Y-%m-%d %T'` <$1> $2"
        echo -e $t
        if [ -z $3 ]; then
                echo -e $t >> $WATCHDOG_LOG
        fi
}

log "INIT" "Booting..."
service_init