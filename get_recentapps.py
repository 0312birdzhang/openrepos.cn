#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''
Created on 2018年10月24日

@author: debo.zhang
'''
import requests
import json
import time

url = "https://openrepos.net/api/v1/apps"
headers = {
    "Accept-Language": "zh",
    "Warehouse-Platform": "SailfishOS"
    }
params = {
    "pagesize": 10,
    "page": 1
    }
try:
    r = requests.get(url, headers = headers, params=params)
    apps_recent = json.loads(r.text)
    user_apps = list()
    for i in apps_recent:
        update_time=int(i.get("updated"))
        if int(time.time()) - update_time <= 5 * 60:
            user_apps.append("{}/personal/main/{}".format(i.get("user").get("name"), i.get("package").get("name")[0]))
    if len(apps_recent) > 0:
        print(" ".join(set(user_apps)))
    else:
        print("")
except Exception as e:
    print("")
