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

function copyPicture {
    cp $PICTURE $YEAR/$MONTH/$PICTURE;
}

while getopts ":hasm" opt; do
  case ${opt} in
    h ) echo 'Help'
      ;;
    a ) for picture in *.jpg;
        do
            [ -e "$picture" ] || continue
            PICTURE=${picture};
            readDate $PICTURE;
            checkFolder;
            copyPicture;
        done
      ;;
    m ) for picture in *.jpg;
        do
            [ -e "$picture" ] || continue
            PICTURE=${picture};
            readDate $PICTURE;
            checkFolder;
            movePicture;
        done
      ;;
    s ) readDate $2;
        checkFolder;
        copyPicture;
      ;;
  esac
done