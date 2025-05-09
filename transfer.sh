#!/bin/bash

check_port() {
   local host = $1
   local port = $2
   (echo >/dev/tcp/$host/$port)> dev/null 2>&11
    # nc -zv -w 3 "$host" "$port" >/dev/null 2>&1

   if [$? -ne 0]; then
      echo "port($port) on $host is open "
   else 
      echo " $port on $ host is closed or host is unreachable "
   fi
}

read -p "enter source username : " source_user 
read -p "enter source Host (IP) : " source_host
read -p "enter source SSH port[default 22]: "source_port
source_port=${source_port:-22}
read -p "enter full path to the souce file : " source_file

read -p "enter destination username : " dest_user
read -p "enter destination Host (IP) : " dest_host
read -p "enter destination SSH port[default 22] : " dest_port
dest_port=${dest_port:-22}
read -p "enter destination directory path : " dest_path

check_port "$source_host" "$source_port"
check_port "$dest_host" "$dest_port"

temp_file ="/tmp/$(basename $source_file)"

scp -P $source_port ${source_user}@${source_host}:${source_file} "$temp_file"
if [$? -ne 0]; then
   echo "failed to copy file from the source server"
fi

ssh -p $dest_port ${dest_user}@${dest_host} "mkdir -p ${dest_path}"
if [$? -ne 0]; then
   echo "failed to connect or create directory on tghe destination server"
   rm -f "$temp_file"
fi

scp -P $dest_port "$temp_file" ${dest_user}@${dest_host}:${dest_path}
status=$?

if [ $status -eq 0]; then 
    echo "file transfer successful"
else
    echo "file transfer failed"
fi 

rm -f "$temp_file"

