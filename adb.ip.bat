FOR /F "tokens=* USEBACKQ" %%F IN (`adb shell "ip addr show wlan0 | grep -e wlan0$ | cut -d\" \" -f 6 | cut -d/ -f 1"`) DO (
SET adbip=%%F
)
ECHO adb connect %adbip%:5555
adb connect %adbip%:5555