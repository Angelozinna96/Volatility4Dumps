#!/bin/sh
PROF_NAME=$1
DUMP_LOC=$2
VOL_LOC=$3
PATH_SAVE="./"
echo "seaching gnome-keyring-d pid..."
RES=($(python "$VOL_LOC"/vol.py -f "$DUMP_LOC" --profile="$PROF_NAME" linux_pslist |grep gnome-keyring-d))
pid=${RES[2]}
if [ -z "$pid" ]
then
	echo "gnome-keyring-d pid not found!"
	exit 0
fi
echo "gnome-keyring-d pid="$pid
echo "seaching gnome-keyring-d potential sectors..."
RES=($(python "$VOL_LOC"/vol.py -f "$DUMP_LOC" --profile="$PROF_NAME" linux_proc_maps -p $pid |tail -8 |head -3))
ADDRESSES=()
for i in "${!RES[@]}";do
	if [ ${RES[i]} == "gnome-keyring-d" ];then
		ADDRESSES+=(${RES[i+1]} )
	fi
done

for addr in "${!ADDRESSES[@]}";do
	echo "potential_start_addr_"$addr" = "${ADDRESSES[addr]}
	echo "extration of the memory sector..."
	RES=$(python "$VOL_LOC"/vol.py -f "$DUMP_LOC" --profile="$PROF_NAME" linux_dump_map -p $pid -s ${ADDRESSES[addr]} --dump-dir="$PATH_SAVE")
done
echo "running python script for searching potential passwords..."
ls $PATH_SAVE"task."$pid"."*
python3 search_possible_pass_from_gdm-kering-d.py $(ls $PATH_SAVE"task."$pid"."*)
echo "possible usernames:"
strings "$DUMP_LOC" |grep -m 10 ^USERNAME= |sort |uniq

rm -f $PATH_SAVE"task."$pid"."*