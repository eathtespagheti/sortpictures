#!/bin/bash

function modIFS {
    originalIFS=$IFS;
	IFS=$(echo -en "\n\b");
}

function restoreIFS {
    IFS=originalIFS;
}

function readDate {
    modIFS;
    DATE=`identify -format %[EXIF:DateTimeOriginal] $PICTURE`;
    if [ $? -eq 0 ]; then
        YEAR=$(echo ${DATE::4});
        MONTH=$(echo ${DATE:5:2});
    else
        echo 'Error reading DateTime value in picture:';
        echo $DATE;
        YEAR='Others';
        MONTH='Others';
    fi
    restoreIFS;
}

function checkFolder {
    # check year folder
    if [ ! -d $YEAR ];
    then
        echo $YEAR Folder not found;
        folderResult=`mkdir $YEAR`;
        if [ $? -eq 0 ]; then
            echo $YEAR Folder created;
        else
            echo Error creating $YEAR folder:;
            echo $folderResult;
        fi
    fi
    if [ ! -d $YEAR/$MONTH ];
    then
        echo $YEAR/$MONTH Folder not found;
        folderResult=`mkdir $YEAR/$MONTH`;
        if [ $? -eq 0 ]; then
            echo $YEAR/$MONTH Folder created;
        else
            echo Error creating $YEAR/$MONTH folder:;
            echo $folderResult;
        fi
    fi
}

function movePicture {
    modIFS;
    mv $PICTURE $YEAR/$MONTH/$PICTURE;
    restoreIFS;
}

function copyPicture {
    modIFS;
    cp $PICTURE $YEAR/$MONTH/$PICTURE;
    restoreIFS;
}

function countPictures {
    pictureNumber=0;
    for picture in *.jpg;
    do
        ((pictureNumber++));
    done
}

while getopts ":hasmc" opt; do
    case ${opt} in
        h ) echo 'Help'
        ;;
        a ) countPictures;
            picturesProcessed=0;
            for picture in *.jpg;
            do
                [ -e "$picture" ] || continue
                PICTURE=${picture};
                readDate $PICTURE;
                checkFolder;
                copyPicture;
                ((picturesProcessed++));
                echo $picturesProcessed pictures copied of $pictureNumber;
            done
        ;;
        c ) countPictures;
            echo There are $pictureNumber pictures;
        ;;
        m ) countPictures;
            picturesProcessed=0;
            for picture in *.jpg;
            do
                [ -e "$picture" ] || continue
                PICTURE=${picture};
                readDate;
                checkFolder;
                movePicture;
                ((picturesProcessed++));
                echo $picturesProcessed pictures moved of $pictureNumber;
            done
        ;;
        s ) readDate $2;
            checkFolder;
            copyPicture;
        ;;
    esac
done