**目的：**

hbase进行major compact的时候会占用大量资源，集群的读写性能都会受到一定的影响，为了不影响线上生产，我们关闭了hbsae自主major compact的功能，使用脚本在服务空闲时进行major compact。

**实现过程：**

1.在同一集群中我们将所有表分为七份，然后每天凌晨major compact一份，这样一周就可以使集群所有的表都major compact一次。将所有表分为七份的脚本为get-daily-table-list.sh
