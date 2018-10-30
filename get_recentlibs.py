#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''
Created on 2018年10月24日

@author: debo.zhang
'''
import requests
import json
import time

headers = {'user-agent': "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.67 Safari/537.36"}
params = {
        "view_content_types": "sailfish_app"
        }
try:
    r = requests.get("https://openrepos.net/category/libraries", headers = headers, params = params)
    html = r.text
    soup = BeautifulSoup(html,"html5lib")
    contents = soup.findAll("span", attrs={"class":"field-content app-title"})
    libs = list()
    for i in contents:
        href = i.find("a").get("href")
        user = href.split("/")[2]
        lib = href.split("/")[-1]
        libs.append("{}/personal/main/{}".format(user, lib[0]))
    print(" ".join(set(libs)))
except Exception as e:
    print("")
