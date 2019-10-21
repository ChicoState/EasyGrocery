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

#Grabs all links on the first page to all of the aisles
a_elements = [] #Aisle elements
driver.get("https://shop.safeway.com/aisles.3132.html") #Main aisle homepage
elements = driver.find_elements_by_class_name('productaislelist')

for block in elements:
    x = block.find_elements_by_class_name('aisle-two')
    for el in x:
        a_elements.append(el.get_attribute('href'))            

#This for loop goes through all the links then performs actions on each one
for link in a_elements:
    driver.get(link)
    time.sleep(3)

    # do stuff within that page here...
    sa_elements = [] #Specific Aisle's elements
    ul = driver.find_element_by_xpath("/html/body/div[2]/div/div/div[2]/div/div/div/div[2]/div/div/div[1]/div/div/nav/ul[2]")
    li = ul.find_elements_by_tag_name('li')
    for these in li:
        a_tag = these.find_element_by_tag_name('a')
        sa_elements.append(a_tag.get_attribute('href'))
    for sap in sa_elements:
        driver.get(sap)

        # Keeps clicking load button if available
        while True:
            try:
                loadMoreButton = driver.find_element_by_xpath("//*[@id='hybrid-product-grid_0']/div[2]/button")
                time.sleep(2)
                driver.execute_script("arguments[0].click();", loadMoreButton)
                time.sleep(2)
            except Exception as e:
                print(e)
                break
        time.sleep(2)

        content = driver.page_source
        soup = BeautifulSoup(content, "html.parser")


        a = soup.find('div', attrs={'class':'asidediv'})

        for b in a.findAll('div', attrs={'class':'product-grid'}):
            try:
                name=b.find('a', attrs={'class':'product-title'}).text.strip()
                price=b.find('span', attrs={'class':'product-price'}).text.strip()
                price=price[10:]
                f.write(name + ", " + price + "\n")
            except Exception as e:
                print(e)

    driver.back()
    time.sleep(2)

driver.close()
