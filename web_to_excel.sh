#!/bin/bash

echo " enter the URL of web UI or API:"
read url
echo "scraping data from $url"

python3 <<EOF
import requests 
from bs4 import beautifulSoup
import openpyxl

url="$url"

try:
    response = requests.get(url)
    response.raise_for_status()

    content_type = response.headers.get('content-type','')
    wb = openpyxl.workbook()
    ws = wb.active
    ws.title = "WebData"

    if "application/json" in content_type:
       data  = response.json()
       if isinstance(data,list) and isinstance(dta[0],dict):
          headers = list(data[0].keys())
	  ws.append(headers)
	  for item in data:
	      ws.append([item.get(h,"") for h in headers])
       else:
	  ws.append(["unsupported JSON structure"])
    else:
       soup = BeautifulSoup(response.text,"html.praser")
       table = soup.find("table")
       
       if table :
         #parse headers
	 headers = [th.get_text(strip =True) for th in table.find_all("th")]
	 ws.append(headers)

	 for row in table .find all("tr"):
	     cells = row.find_all("td")
	     if cells:
	        ws.append([cells.get_text(strip=True) for cell in cells])

       else:
          ws.append(["no html table found on page"])
    
    output_file = "web_data.xlsx"
    wb.save(ouput_file)
    print("data saved to",output_file)
 
except exception as e:
       print("error occured:",str(e))
EOF

