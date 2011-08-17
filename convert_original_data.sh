#!/bin/bash

# convert original data

#1. convert RGB to gray for all bmp images
ORIGBMPDIR=/mnt/data/songgang/aibs1/data/Histo/Yuko/preliminary_anatomical_new/input/anatomical_input/original_bmp
GRAYBMPDIR=/mnt/data/songgang/aibs1/data/Histo/Yuko/preliminary_anatomical_new/input/anatomical_input/gray_bmp
VOLUMEIMG=/mnt/data/songgang/aibs1/data/Histo/Yuko/preliminary_anatomical_new/input/anatomical_input/volume/anatomical.nii.gz

ORIGMASKDIR=/mnt/data/songgang/aibs1/data/Histo/Yuko/preliminary_anatomical_new/input/anatomical_input/original_mask
GRAYMASKDIR=/mnt/data/songgang/aibs1/data/Histo/Yuko/preliminary_anatomical_new/input/anatomical_input/gray_mask
VOLUMEMASK=/mnt/data/songgang/aibs1/data/Histo/Yuko/preliminary_anatomical_new/input/anatomical_input/volume/anatomical_mask.nii.gz

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




# have to set the printf style of each slice manually now
echo "convert rgb to gray for each anatomical slice"
convert_RGB_to_gray_bmp_series $ORIGBMPDIR $GRAYBMPDIR
echo
echo "convert anotomical slice series to 3d volume"
~tustison/build/Utilities/bin/ConvertImageSeries $GRAYBMPDIR gray_anatomical_image_v1_%05d.bmp $VOLUMEIMG 0 155 1

# have to set the printf style of each slice manually now
echo "convert rgb to gray for each anatomical mask slice"
convert_RGB_to_gray_bmp_series $ORIGMASKDIR $GRAYMASKDIR
echo
echo "convert anotomical mask slice series to 3d volume"
~tustison/build/Utilities/bin/ConvertImageSeries $GRAYMASKDIR gray_anatomical_image_v1msk_bmp_%05d.bmp $VOLUMEMASK 1 156 1
c3d $VOLUMEMASK -thresh 1 Inf 1 0 -o $VOLUMEMASK




