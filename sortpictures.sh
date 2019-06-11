#!/bin/bash

function readDate {
   DATE=`identify -format %[EXIF:DateTime] $1`;
   YEAR=$(echo ${DATE::4});
   MONTH=$(echo ${DATE:5:2});
}

function checkFolder {
    # check year folder
    if [ ! -d $YEAR ];
    then
        echo 'Year Folder not found';
        mkdir $YEAR;
        echo 'Year Folder created';
    fi
    if [ ! -d $YEAR/$MONTH ];
    then
        echo 'Month Folder not found';
        mkdir $YEAR/$MONTH;
        echo 'Month Folder created';
    fi
}

function movePicture {
    mv $PICTURE $YEAR/$MONTH/$PICTURE;
}

PICTURE=$1;
readDate $PICTURE;
checkFolder;
movePicture;