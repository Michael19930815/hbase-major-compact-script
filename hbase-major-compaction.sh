#!/bin/bash
#获取时间戳
curr_date=$(date "+%Y-%m-%d %H:%M:%S")
#周一是1，依次类推，注意周日是0
curr_weekDay=$(date "+%w")
echo "------------------------------------------------------"
echo "start at $curr_date"
echo "today is week of $curr_weekDay"
TABLES_FILE=/data/bigdata/bin/tables.txt-$curr_weekDay
echo "get table name from $TABLES_FILE"
for table in $(cat $TABLES_FILE); do
	echo '**********************************************'
        echo "major_compact '$table'" | hbase shell
        echo "major_compact '$table' over"
	echo ""
        sleep 10
done