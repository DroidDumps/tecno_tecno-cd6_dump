#!/system/bin/sh

DUMP_MODE=0
DUMP_GAP=30

while getopts "d:t:h" arg
do
    case $arg in
        d)
            DUMP_MODE=$OPTARG
            ;;
        t)
            DUMP_GAP=$OPTARG
            ;;
        h)
            echo "-d: dump hprof file, default don't dump hprof file, 1: dump system_sever, 2: dump systemui, 3: dump system_server and systemui"
            echo "-t: the frequency of dumpheap, default is 60 mins"
            ;;
        *)
            echo "unknow argument"
            ;;
    esac
done

rm -rf /sdcard/meminfo
mkdir /sdcard/meminfo
mkdir /sdcard/meminfo/meminfo
log_path="/sdcard/meminfo/meminfo"

getprop | tee /sdcard/meminfo/prop.txt
cat /sdcard/meminfo/prop.txt | grep "ro.product.device" | tee -a /sdcard/meminfo/deviceinfo.txt
cat /sdcard/meminfo/prop.txt | grep "ro.build.display.id" | tee -a /sdcard/meminfo/deviceinfo.txt
cat /sdcard/meminfo/prop.txt | grep "ro.build.version.release" | tee -a /sdcard/meminfo/deviceinfo.txt
cat /sdcard/meminfo/prop.txt | grep "ro.board.platform" | tee -a /sdcard/meminfo/deviceinfo.txt
cat /sdcard/meminfo/prop.txt | grep "ro.os_product.version" | tee -a /sdcard/meminfo/deviceinfo.txt
cat /sdcard/meminfo/prop.txt | grep "ro.config.low_ram" | tee -a /sdcard/meminfo/deviceinfo.txt
wm size | tee -a /sdcard/meminfo/deviceinfo.txt
cat /proc/version | awk '{print "kernel_version: " $3} ' | tee -a /sdcard/meminfo/deviceinfo.txt
cat /proc/meminfo | grep "MemTotal" | tee -a /sdcard/meminfo/deviceinfo.txt

#echo "dump_memory_parameter" | tee -a /sdcard/meminfo/deviceinfo.txt
cd /proc/sys/vm/
ls | awk '{print $0 ":" ;cmd="cat "$0; system(cmd);}' | tee -a /sdcard/meminfo/memory_para.txt

cat /proc/mtk_memcfg/reserve_memory | tee /sdcard/meminfo/reserve_memory.txt
cd /sys/module/lowmemorykiller/parameters
echo "adj" | tee -a /sdcard/meminfo/memory_para.txt
cat adj | tee -a /sdcard/meminfo/memory_para.txt
echo "minfree" | tee -a /sdcard/meminfo/memory_para.txt
cat minfree | tee -a /sdcard/meminfo/memory_para.txt
dumpsys package | tee /sdcard/meminfo/package.txt

last_time=$(date +%s)
count=0

let time_gap=$DUMP_GAP*60
let "system_flag=$DUMP_MODE&1"
let "systemui_flag=$DUMP_MODE&2"

tmp_path=/data/local/tmp
hprof_path=$tmp_path/hprof
mkdir $hprof_path

if [ $DUMP_MODE -ne '0' ]; then
 dumpsys activity dumpheapops on
fi

while (true)
do
time=`date '+%Y_%m%d_%H%M%S_%N'`
dumpsys -t 60 meminfo        | tee -a $log_path/dumpsys_meminfo_$time.txt
cat /proc/meminfo            | tee -a $log_path/dumpsys_meminfo_$time.txt
cat /proc/vmallocinfo | grep vmalloc | awk '{sum = sum + $2} END {print "vmalloc:", sum/1024}' | tee -a $log_path/dumpsys_meminfo_$time.txt
cat /d/ion/ion_mm_heap | grep "  total orphaned" | tee -a $log_path/dumpsys_meminfo_$time.txt
cat /d/ion/ion_mm_heap | grep "          total"  | tee -a $log_path/dumpsys_meminfo_$time.txt
curr_time=$(date +%s)
echo $curr_time
let gap=$curr_time-$last_time
echo $gap
echo $time_gap
echo $system_flag
echo $systemui_flag

if [ $gap -gt $time_gap ]; then
if [ "$system_flag" -ne "0" ]; then
am dumpheap system $hprof_path/systemserver_$time.hprof
fi
if [ "$systemui_flag" -ne "0" ]; then
am dumpheap com.android.systemui $hprof_path/systemui_$time.hprof
fi
last_time=$(date +%s)
fi
echo "------------------------------------"
count=$(($count+1))
echo "cout: " $count
sleep 1
done
