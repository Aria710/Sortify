#!/system/bin/sh
# Sortify v4.0 Service (Native WebUI Version)

MODDIR=${0%/*}
CONF="$MODDIR/sortify.conf"
LOG="$MODDIR/sortify.log"

# 1. Load Defaults if config missing
if [ ! -f "$CONF" ]; then
    echo "INTERVAL=300" > "$CONF"
fi

# (WebUI is now handled natively by KernelSU via 'webroot' folder. No httpd needed.)

# 2. Wait for Storage
wait_until_storage() {
    until [ -d "/sdcard/Download" ]; do
        sleep 10
    done
}
wait_until_storage

# 3. Main Loop (Backgrounded)
(
    while true; do
        # Re-read config every cycle to get new INTERVAL
        if [ -f "$CONF" ]; then
            source "$CONF"
        fi
        
        # Run the action script and throw away all output
        sh "$MODDIR/action.sh" > /dev/null 2>&1
        
        sleep "${INTERVAL:-300}"
    done
) &  # <--- CRITICAL: Run entire loop in background
