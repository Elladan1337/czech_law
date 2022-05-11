# IMPORTANT LEGAL WARNING
# Before running this script make sure to read the T&C of the Business Register website at:
# https://or.justice.cz/ias/ui/podminky
# It is forbidden to make more than 50 requests per minute, or 3000 requests per day.
# This script is distributed under a AGPL-3.0 license.

# Importing the necessary libraries
import requests
from lxml import etree
from bs4 import BeautifulSoup


# Creates the correct URL based on whether a number or name was inputted.
def url_creator(identifier):
    if identifier.isnumeric():  # ICO
        url = ('https://or.justice.cz/ias/ui/rejstrik-$firma?p%3A%3Asubmit=x&.%2Frejstrik-%24firma=&nazev=&ico=' +
               str(identifier) +
               '&obec=&ulice=&forma=&oddil=&vlozka=&soud=&polozek=50&typHledani=STARTS_WITH&jenPlatne=PLATNE'
               '&typHledaniSpolku=ALL')
    else:
        url = ('https://or.justice.cz/ias/ui/rejstrik-$firma?p%3A%3Asubmit=x&.%2Frejstrik-%24firma=&nazev=' +
               str(identifier) +
               '&ico=&obec=&ulice=&forma=&oddil=&vlozka=&soud=&polozek=50&typHledani=STARTS_WITH&jenPlatne=PLATNE'
               '&typHledaniSpolku=ALL')
    return url


# Requests the website, I am not entirely sure what happens here, but it works.
def retrieve(url):
    webpage = requests.get(url)
    webpage = BeautifulSoup(webpage.content, 'html.parser')
    webpage = etree.HTML(str(webpage))                      # etree is used because BS4 doesn't support XPath
    return webpage


# Uses XPath to return a dictionary of the relevant information.
def credentialize(webpage):
    credentials = {'address': webpage.xpath('//*[@id="idd"]/div/span/span')[0].text,
                   'name': webpage.xpath('//*[@id="SearchResults"]/div[2]/div/ol/li/div/'
                                         'table/tbody/tr[1]/td[1]/strong')[0].text,
                   'ico': (webpage.xpath('//*[@id="SearchResults"]/div[2]/div/ol/li/div/'
                                         'table/tbody/tr[1]/td[2]/strong/span/text()[1]')[0]) + " " +
                          (webpage.xpath('//*[@id="SearchResults"]/div[2]/div/ol/li/div/'
                                         'table/tbody/tr[1]/td[2]/strong/span/text()[2]')[0]) + " " +
                          (webpage.xpath('//*[@id="SearchResults"]/div[2]/div/ol/li/div/'
                                         'table/tbody/tr[1]/td[2]/strong/span/text()[3]')[0])}
    return credentials


# Pastes the relevant information into a format commonly used by lawyers.
def outputter(credentials):
    output = 'Společnost ' + credentials['name'] + ' se sídlem na adrese ' + credentials['address'] + ' IČ: ' + \
             credentials['ico'] + '.'
    return output


def main():
    print("Enter company name or identification number")
    identifier = input()
    print(outputter(credentialize(retrieve(url_creator(identifier)))))


main()
