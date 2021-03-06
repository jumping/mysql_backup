#!/bin/bash
# mysql_backup.sh: backup mysql databases and keep newest 5 days backup.  
#  
# ${db_user} is mysql username  
# ${db_password} is mysql password  
# ${db_host} is mysql host   
# ！！！！！！！！！�C  
#/root/mysql_backup.sh
# every 30 minute AM execute database backup
# */30 * * * * /root/mysql_backup.sh
#/etc/cron.daily
#恷挫慧壓貫垂嶄肇姥芸��辛參契峭麼垂壓姥芸扮議迄燕

# the directory for story your backup file.  #
backup_dir="/var/log/mysql/binlog/"

# 勣隠藻議姥芸爺方 #
backup_day=10

#方象垂姥芸晩崗猟周贋刈議揃抄
logfile="/var/log/binlog_backup.log"

###ssh極笥催###
ssh_port=1204
###協吶ssh auto key議猟周###
id_rsa=/root/auth_key/id_rsa_153.141.rsa
###協吶ssh auto username###
id_rsa_user=rsync
###協吶勣揖化議垓殻捲暦匂議朕村揃抄�┗慚詈脳�斤揃抄��###
clientPath="/home/backup/mysqlbinlog"
###協吶勣承�餤脹承慘勅�朕村揃抄 坿捲暦匂�┗慚詈脳�斤揃抄��###
serverPath=${backup_dir}
###協吶伏恢桟廠議ip###
web_ip="192.168.0.2"

# date format for backup file (dd-mm-yyyy)  #
time="$(date +"%Y-%m-%d")"

# the directory for story the newest backup  #
test ! -d ${backup_dir} && mkdir -p ${backup_dir}

delete_old_backup()
{    
    echo "delete old binlog file:" >>${logfile}
    # 評茅症議姥芸 臥孀竃輝念朕村和鈍爺念伏撹議猟周��旺繍岻評茅
    find ${backup_dir} -type f -mtime +${backup_day} | tee delete_binlog_list.log | xargs rm -rf
    cat delete_binlog_list.log >>${logfile}
}

rsync_mysql_binlog()
{
    # rsync 揖化欺凪麿Server嶄 #
    for j in ${web_ip}
    do                
        echo "mysql_binlog_rsync to ${j} begin at "$(date +'%Y-%m-%d %T') >>${logfile}
        ### 揖化 ###
        rsync -avz --progress --delete --include="mysql-bin.*" --exclude="*" $serverPath -e "ssh -p "${ssh_port}" -i "${id_rsa} ${id_rsa_user}@${j}:$clientPath >>${logfile} 2>&1 
        echo "mysql_binlog_rsync to ${j} done at "$(date +'%Y-%m-%d %T') >>${logfile}
    done
}

#序秘方象垂姥芸猟周朕村
cd ${backup_dir}

#delete_old_backup
rsync_mysql_binlog

echo -e "========================mysql binlog backup && rsync done at "$(date +'%Y-%m-%d %T')"============================\n\n">>${logfile}
cat ${logfile}


