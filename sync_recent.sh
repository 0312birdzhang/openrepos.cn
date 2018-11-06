#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
run_nums=$(ps -ef|grep sync_recent.sh|grep -v grep|wc -l)
if [ "$run_nums" -gt "2" ];then
  echo "prev task not done"
  exit 0
fi

ip="192.168.1.172:41000"
export http_proxy=$ip
export https_proxy=$ip
cd /data
recentapps=$(python3 /data/get_recentapps.py)
recentapps="$recentapps" $(python3 /data/get_recentlibs.py)
for line in ${recentapps}
do
  if [ "$line" = "" ];then
   continue
  fi
  #olf/personal/main/m
   repos="https://sailfish.openrepos.net/${line}/"
   user=$(echo $line|awk -F '/' '{print $1}')
   wget --header="Referer: https://sailfish.openrepos.net/${line}/personal/main/" \
    --header="User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.67 Safari/537.36" \
    -np \
    -nc \
    -R "index.html*, *.xml, *.xml.gz, *.xml.asc, *.sqlite.bz2" \
    -c -r -L -p ${repos}
   if [ -d "sailfish.openrepos.net/${line}" ];then
       sed -i 's/openrepos-/openrepos.cn-/' sailfish.openrepos.net/${user}/personal-main.repo
       createrepo -update sailfish.openrepos.net/${user}/personal/main/
       rm -f sailfish.openrepos.net/${user}/personal/main/repodata/repomd.xml.asc
       gpg --detach-sign --armor sailfish.openrepos.net/${user}/personal/main/repodata/repomd.xml
       echo "signed with gpg"
       echo "Sync done: " ${line}
   fi
   sleep 1
done
