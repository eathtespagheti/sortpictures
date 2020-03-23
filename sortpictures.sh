#!/usr/bin/env bash

EXTENSIONS=(jpg jpeg)
# Add uppercase extensions
for item in ${EXTENSIONS[@]}; do
    EXTENSIONS=(${EXTENSIONS[@]} ${item^^})
done

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
    for extension in ${EXTENSIONS[@]}; do
        for picture in *.$extension; do
            ((pictureNumber++))
        done
    done
}

function printHelp() {
    echo "Usage: sortpicture -<option> <file>"
    echo
    echo "Options are:"
    echo "h         : print help message"
    echo "i         : print how many pictures there are inside the folder"
    echo "c         : process all pictures in folder copying them"
    echo "m         : process all pictures in folder moving them"
    echo "s pic.jpg : process a single picture (copying it)"
    echo
    echo "Extensions supported"
    echo ${EXTENSIONS[@]}
}

while getopts ":hicms" opt; do
    case ${opt} in
    h)
        printHelp
        ;;
    i)
        countPictures
        echo There are $pictureNumber pictures
        ;;
    c)
        countPictures
        picturesProcessed=0
        for extension in ${EXTENSIONS[@]}; do
            for picture in *.$extension; do
                [ -e "$picture" ] || continue
                PICTURE=${picture}
                readDate $PICTURE
                checkFolder
                copyPicture
                ((picturesProcessed++))
                echo $picturesProcessed pictures copied of $pictureNumber
            done
        done
        ;;
    m)
        countPictures
        picturesProcessed=0
        for extension in ${EXTENSIONS[@]}; do
            for picture in *.$extension; do
                [ -e "$picture" ] || continue
                PICTURE=${picture}
                readDate $PICTURE
                checkFolder
                movePicture
                ((picturesProcessed++))
                echo $picturesProcessed pictures moved of $pictureNumber
            done
        done
        ;;
    s)
        readDate $2
        checkFolder
        copyPicture
        ;;
    esac
done
