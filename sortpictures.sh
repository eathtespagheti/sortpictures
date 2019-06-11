#!/bin/bash

function readDate {
   DATE=`identify -format %[EXIF:DateTime] $1`;
   YEAR=$(echo ${DATE::4});
   MONTH=$(echo ${DATE:5:2});
   DAY=$(echo ${DATE:8:2});
   echo $YEAR;
   echo $MONTH;
   echo $DAY;
}

readDate cc.jpg