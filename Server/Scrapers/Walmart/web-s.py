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

os.remove("output.txt")
driver = webdriver.Chrome("./chromedriver")
f = open("output.txt", "a")

def doPage(x):
    driver.get(x)

    def writeCurPage():
        content = driver.page_source
        soup = BeautifulSoup(content, "html.parser")

        for b in soup.findAll('div', attrs={'class':'search-result-gridview-item-wrapper'}):
            name=b.find('a', attrs={'class':'product-title-link line-clamp line-clamp-2'}).get('title').replace(",", " ")
            price=b.find('span', attrs={'class':'price-group'})
            if price is not None:
                price = price.text.strip()
                f.write(name + ", " + price + "\n")

    while True:
        try:
            writeCurPage()
            nextPage = driver.find_element_by_class_name('paginator-btn-next')
            driver.execute_script("arguments[0].click();", nextPage)
            time.sleep(2)
        except Exception as e:
            print(e)
            break

doPage("https://www.walmart.com/browse/food/976759?grid=true&stores=2044") #Food page
doPage("https://www.walmart.com/browse/baby/baby-formula/5427_133283_1001447?stores=2044") #Baby Formula
doPage("https://www.walmart.com/browse/baby/baby-food/5427_133283_1001448?stores=2044") #Baby food
doPage("https://www.walmart.com/browse/baby/baby-wipes/5427_486190_1096134?stores=2044") #Baby wipes
doPage("https://www.walmart.com/browse/baby/diapers/5427_486190_1101406?stores=2044") #Baby diapers
doPage("https://www.walmart.com/browse/pets/all-dry-dog-food/5440_202072_6432755_1636265?stores=2044") #Dry dog food
doPage("https://www.walmart.com/browse/pets/all-dry-cat-food/5440_202073_1749780_3053202_1388118?povid=202073+%7C+2018-04-30+%7C+dry+cat+food&stores=2044") #Dry cat food
driver.close()
