#/bin/bash
#when you use this shell for back up directories, do things below first
#1: create backup dir /data/web_backups
#2: modify mysql user,password and database name

#make tempory dir, your files would be copy to this dir for the next tar
tmp_p_dir=/tmp
tmp_dir_name=tmp_backup
tmp_dir=$tmp_p_dir/$tmp_dir_name
#if not exist, create it
if [ ! -d $tmp_dir ]
then
    mkdir -p $tmp_dir
fi
echo "dir for tar is $tmp_dir"

#code src dir
src_dir="/home/tony/codes/test_tar"
echo "code src dir is $src_dir"
echo "copy src codes to tempory dir..."
`cp -Rp $src_dir $tmp_dir`

date=`date +"%Y%m%d"`

#if Monday , backup the database
if [ `date +%w` -eq 1 ]
then
    echo "moday backup database"
    `mysqldump -uroot -p1 hope > $tmp_dir/db.sql`
fi

#create this dir before crontab
dst_dir="/data/web_backups"
#if not exist, create it
if [ ! -d $dst_dir ] 
then 
    mkdir -p $dst_dir
fi
echo "backup dir is $dst_dir"

dst_path=$dst_dir"/"$date".gz"
echo "backup dst path is $dst_path"
#tar src path must be relative, so cd to src dir first 
tar_dir=`cd $tmp_p_dir && tar -cvf $dst_path $tmp_dir_name`
echo "result is $?"
if [ $? != 0 ]
then
    echo "tar failed, info:";
fi
echo "$tar_dir"

#remove expire backup files (60 days)
echo "remove expired backup files (60 days)"
`find $dst_dir -mtime +60 -type f | xargs rm 2>/dev/null`
