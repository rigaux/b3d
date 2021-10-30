#! /bin/python3
# script de nettoyage pour import dans Moodle
# rfs 20.09.2017

import argparse
import os
import re
from bs4 import BeautifulSoup
import zipfile

def removeDivs(filename):
    html_data = open(filename).read()
    soup = BeautifulSoup(html_data, 'html.parser')
    if soup.title:
        soup.title.decompose()
    if soup.h1:
        soup.h1.decompose() # le 1er H1
    # on enlève le header
    headerDiv = soup.find_all("div", "header-wrapper")
    # et le footer
    footerDiv = soup.find_all("div", "footer-wrapper")
    # et la table des matières
    tocdiv = soup.find_all("div", "sidebar")
    removeDivs = tocdiv + headerDiv + footerDiv 
    for div in removeDivs:
        div.decompose()
    return soup

def changeImageUrls(soup):
    images = soup.find_all("img")
    for image in images:
        attributes = ["src"]
        for attr in attributes:
            image[attr] = image[attr].replace("_images", "http://b3d.bdpedia.fr/_images")
    return soup


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Nettoyage des epub de Sphinx pour import dans Moodle')
    parser.add_argument(
        '--folder',
        type=str,
        help='the name of the folder to process')
    args = parser.parse_args()

    if args.folder is None:
        foldername = '_build/epub'
    else:
        foldername = "./" + args.folder

    htmlfiles = []
    for f in os.listdir(foldername):
        if f.endswith('xhtml'):
            if os.stat(foldername + "/" + f).st_size != 0:
                htmlfiles.append(foldername+"/"+f)

    # et maintenant on les traite
    for filename in htmlfiles:
        print("processing file "+filename)
        # on enlève les divs (header, footer, ToC)
        soup = removeDivs(filename)
        # on remplace les url des images
        prettysoup = changeImageUrls(soup)

        with open(filename, "w") as f:
            f.write(prettysoup.prettify())

    # créons les fichiers zip associés, prêts à l'import
    for filename in htmlfiles:
        zipfilename = filename + ".zip"
        with zipfile.ZipFile(zipfilename, 'w') as myzip:
            arcname = os.path.split(filename)[1]
            absname = filename
            myzip.write(absname,arcname)
    print("Done!")

