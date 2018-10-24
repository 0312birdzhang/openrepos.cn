#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''
Created on 2018年10月24日

@author: debo.zhang
'''

from bs4 import BeautifulSoup
import requests
import time

__PUBLISHERS_URL = "https://openrepos.net/publishers"

def get(page):
    params = {"page": page}
    headers = {'user-agent': "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.67 Safari/537.36"}
    r = requests.get(__PUBLISHERS_URL, params = params, headers=headers)
    html = r.text
    soup = BeautifulSoup(html,"html5lib")
    pager_last = soup.find("li", attrs = {"class": "pager-last last" })

    usernames = soup.find("div", attrs={"class":"region region-content"}).find_all("a", attrs={"class": "username", "typeof": "sioc:UserAccount"})
    for i in usernames:
        print(i.get_text())
    if pager_last:
        # /publishers?page=13
        max_page = int(pager_last.a.get("href").split("=")[1])
        return max_page
    return 0

if __name__ == "__main__":
    page = 0
    max_page = 1
    while max_page >= page:
        max_page = get(page)
        page += 1
        time.sleep(1)
    
    
