#Basic webscraping packages
from selenium import webdriver
from bs4 import BeautifulSoup
import pandas as pd
import os

#For continually loading new products on page
from selenium.common.exceptions import NoSuchElementException
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time

PATIENCE_TIME = 60
LOAD_MORE_BUTTON_XPATH = '//*[@id="hybrid-product-grid_0"]/div[2]/button' 

os.remove("output.txt")
driver = webdriver.Chrome("./chromedriver")
f = open("output.txt", "a")

#driver.get("https://shop.safeway.com/aisles/dairy-eggs-cheese/butter-sour-cream.3132.html")
driver.get("https://shop.safeway.com/aisles/bread-bakery/baguettes-french-bread.3132.html?page=1")

while True:
    try:
        loadMoreButton = driver.find_element_by_xpath("//*[@id='hybrid-product-grid_0']/div[2]/button")
        time.sleep(5)
        driver.execute_script("arguments[0].click();", loadMoreButton)
        #loadMoreButton.click()
        time.sleep(5)
    except Exception as e:
        print(e)
        break
print ("Complete")
time.sleep(10)

content = driver.page_source
soup = BeautifulSoup(content, "html.parser")


a = soup.find('div', attrs={'class':'asidediv'})

for b in a.findAll('div', attrs={'class':'product-grid'}):
    name=b.find('a', attrs={'class':'product-title'}).text.strip()
    price=b.find('span', attrs={'class':'product-price'}).text.strip()
    price=price[10:]
    f.write(name + ", " + price + "\n")

driver.close()
