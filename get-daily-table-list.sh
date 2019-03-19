#!/bin/bash
#原始输出保存路径
TMP_FILE=/data/bigdata/tmp/tmp_tables
#去掉多余行只有表名的保存路径
TABLES_FILE=/data/bigdata/bin/tables.txt
#将所有表分为7份
split_num=7
#现在的时间，打入日志
curr_date=$(date "+%Y-%m-%d %H:%M:%S")
echo "------------------------------------------------------"
echo "start at $curr_date"
#将原始输出保存
echo "list" | hbase shell > $TMP_FILE
sleep 2
echo "get list from hbase"
#去掉多余行
sed '1,6d' $TMP_FILE | tac | sed '1,3d' | tac > $TABLES_FILE
sleep 2
echo "get table name from $TMP_FILE complete"
#计算总行数/表数
total_num=`cat ${TABLES_FILE} | wc -l`
#每天需要major_compact的表的数量
split_rows=`expr ${total_num} / ${split_num}`
#当集群中的表的数量小于7时将每天major compact的数置为1
if split_rows==0;then
split_rows=1
split_num=${total_num}
fi
#结束行
end_row=0
i=1
for((; i < ${split_num}; i++))
do
end_row=`expr ${split_rows} \* ${i}`
#分成7份，每份文件的id
FILE_NUM=$[i%split_num]
#截取
head -${end_row} ${TABLES_FILE} | tail -${split_rows} > ${TABLES_FILE}-${FILE_NUM}
done
#文件0
tail -`expr ${total_num} - ${end_row}` ${TABLES_FILE} > ${TABLES_FILE}-$[i%split_num]
