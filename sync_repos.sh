#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ip="192.168.1.172:41000"
export http_proxy=$ip
export https_proxy=$ip
cd /data
while read line
  do
   repos="https://sailfish.openrepos.net/${line}/"
   wget --header="Referer: https://sailfish.openrepos.net/${line}/personal/main/" \
    --header="User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.67 Safari
/537.36" \
    -np \
    -nc \
    -R "index.html*, *.xml, *.xml.gz, *.xml.asc, *.sqlite.bz2" \
    -c -r -L -p ${repos}
   if [ -d "sailfish.openrepos.net/${line}" ];then
       find . -name index.html -delete
       find ./sailfish.openrepos.net/${line}/ -name repomd.xml.asc -delete
       sed -i 's/sailfish.openrepos.net/openrepos.qiyuos.cn/' $(grep -rl "sailfish.openrepos.net" sailfish.openrepos.net/${line})
       sed -i 's/openrepos-/openrepos.cn-/' sailfish.openrepos.net/${line}/personal-main.repo
       createrepo -update sailfish.openrepos.net/${line}/personal/main/
       echo '$passphrase' |gpg --passphrase-fd 0 --trust-model always --detach-sign --armor sailfish.openrepos.net/${line}/persona
l/main/repodata/repomd.xml
       echo "signed with gpg"
       echo "Sync done: " ${line}
   fi
   sleep 10
done < publisher.txt
