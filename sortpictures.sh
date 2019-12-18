#!/bin/bash

function readDate() {
    DATE=$(identify -format %[EXIF:DateTimeOriginal] $1)
    if [ $? -eq 0 ]; then
        YEAR=$(echo ${DATE::4})
        MONTH=$(echo ${DATE:5:2})
    else
        echo 'Error reading DateTime value in picture:'
        echo $DATE
        YEAR='Others'
        MONTH=''
    fi
}

function checkFolder() {
    # check year folder
    if [ ! -d $YEAR ]; then
        echo $YEAR Folder not found
        folderResult=$(mkdir $YEAR)
        if [ $? -eq 0 ]; then
            echo $YEAR Folder created
        else
            echo Error creating $YEAR folder:
            echo $folderResult
        fi
    fi
    if [ ! -d $YEAR/$MONTH ]; then
        echo $YEAR/$MONTH Folder not found
        folderResult=$(mkdir $YEAR/$MONTH)
        if [ $? -eq 0 ]; then
            echo $YEAR/$MONTH Folder created
        else
            echo Error creating $YEAR/$MONTH folder:
            echo $folderResult
        fi
    fi
}

function movePicture() {
    mv $PICTURE $YEAR/$MONTH/$PICTURE
}

function copyPicture() {
    cp $PICTURE $YEAR/$MONTH/$PICTURE
}

function countPictures() {
    pictureNumber=0
    for picture in *.jpg; do
        ((pictureNumber++))
    done
}

while getopts ":hicms" opt; do
    case ${opt} in
    h)
        echo 'Help'
        ;;
    i)
        countPictures
        echo There are $pictureNumber pictures
        ;;
    c)
        countPictures
        picturesProcessed=0
        for picture in *.jpg; do
            [ -e "$picture" ] || continue
            PICTURE=${picture}
            readDate $PICTURE
            checkFolder
            copyPicture
            ((picturesProcessed++))
            echo $picturesProcessed pictures copied of $pictureNumber
        done
        ;;
    m)
        countPictures
        picturesProcessed=0
        for picture in *.jpg; do
            [ -e "$picture" ] || continue
            PICTURE=${picture}
            readDate $PICTURE
            checkFolder
            movePicture
            ((picturesProcessed++))
            echo $picturesProcessed pictures moved of $pictureNumber
        done
        ;;
    s)
        readDate $2
        checkFolder
        copyPicture
        ;;
    esac
done
