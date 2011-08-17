#!/bin/bash

# convert original data

GENE=$1
# GENE=E80_00876


#1. convert RGB to gray for all bmp images
ORIGBMPDIR=/home/songgang/mnt/data/Histo/Yuko/preliminary_anatomical_new/input/new12case/ViBrismSamplesBMP/$GENE
GRAYBMPDIR=/home/songgang/mnt/data/Histo/Yuko/preliminary_anatomical_new/input/new12case/$GENE/gray_bmp
VOLUMEIMG=/home/songgang/mnt/data/Histo/Yuko/preliminary_anatomical_new/input/new12case/$GENE/volume/$GENE.nii.gz
VOLUMEIMGNEW=/home/songgang/mnt/data/Histo/Yuko/preliminary_anatomical_new/input/new12case/$GENE/volume/${GENE}_reheadered.nii.gz
VOLUMEMASK=/home/songgang/mnt/data/Histo/Yuko/preliminary_anatomical_new/input/new12case/$GENE/volume/${GENE}_reheadered_mask.nii.gz


function ConfirmDirectory 
{
#    echo $1
	if [ ! -d $1 ]
	then
	   echo "==> create new directory: " $1
	   mkdir -p $1
	fi
}



function convert_RGB_to_gray_bmp_series {

local ORIGBMPDIR=$1
local GRAYBMPDIR=$2


   SAVEIFS=$IFS
   IFS=$(echo -en "\n\b")
   for a in $ORIGBMPDIR/*.bmp
   do
       aname=`basename $a .bmp`
       echo $aname
       anametr=$(echo $aname | tr ' ' _ | tr \" ' ') #replace white space with _ and remove quotes.
       echo $anametr
  
#GS: note: must add -type TrueColor to make the class as DirectClass not PseudoClass (dunno what is this!!!)
       convert $a -colorspace gray -type TrueColor $GRAYBMPDIR/gray_${anametr}.bmp


    done
    IFS=$SAVEIFS
}


function reheader {

local OLDIMG=$1
local NEWIMG=$2

c3d $OLDIMG -spacing 0.0456x0.0456x0.05mm -o $NEWIMG
~tustison/build/Utilities/bin/PermuteAxesImage 3 $NEWIMG $NEWIMG 1x0x2
c3d $NEWIMG -orient RAI -o $NEWIMG
~tustison/build/Utilities/bin/FlipImage 3 $NEWIMG $NEWIMG 0x1x0
c3d $NEWIMG -origin 0x0x0mm -o $NEWIMG

}

# prepare all the output and intermediate directories
ConfirmDirectory $GRAYBMPDIR
ConfirmDirectory `dirname $VOLUMEIMG`
ConfirmDirectory `dirname $VOLUMEIMGNEW`
ConfirmDirectory `dirname $VOLUMEMASK`


# have to set the printf style of each slice manually now
echo "convert rgb to gray for each anatomical slice"
convert_RGB_to_gray_bmp_series $ORIGBMPDIR $GRAYBMPDIR
echo

echo "convert anotomical slice series to 3d volume"
CNTFILE=`ls -l $GRAYBMPDIR/gray_${GENE}_*.bmp | wc -l`
echo total $CNTFILE files
echo
~tustison/build/Utilities/bin/ConvertImageSeries $GRAYBMPDIR gray_${GENE}_%03d.bmp $VOLUMEIMG 0 `echo $CNTFILE-1 | bc` 1
echo


echo "reset the image header"
reheader $VOLUMEIMG $VOLUMEIMGNEW
echo

echo "get the binary volume mask"
c3d $VOLUMEIMGNEW -thresh 1 Inf 1 0 -o $VOLUMEMASK
echo

