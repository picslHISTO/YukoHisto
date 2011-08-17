# history record:
# in dir:
# /mnt/data/songgang/aibs1/data/Histo/Yuko/preliminary_anatomical_new/input/anatomical_input/volume



function reheader {

local OLDIMG=$1
local NEWIMG=$2

c3d $OLDIMG -spacing 0.0456x0.0456x0.05mm -o $NEWIMG
~tustison/build/Utilities/bin/PermuteAxesImage 3 $NEWIMG $NEWIMG 1x0x2
c3d $NEWIMG -orient RAI -o $NEWIMG
~tustison/build/Utilities/bin/FlipImage 3 $NEWIMG $NEWIMG 0x1x0
c3d $NEWIMG -origin 0x0x0mm -o $NEWIMG

}


OLDIMG=/mnt/data/songgang/aibs1/data/Histo/Yuko/preliminary_anatomical_new/input/anatomical_input/volume/anatomical.nii.gz
NEWIMG=/mnt/data/songgang/aibs1/data/Histo/Yuko/preliminary_anatomical_new/input/anatomical_input/volume/anatomical_reheadered.nii.gz

reheader $OLDIMG $NEWIMG

OLDMASK=/mnt/data/songgang/aibs1/data/Histo/Yuko/preliminary_anatomical_new/input/anatomical_input/volume/anatomical_mask.nii.gz
NEWMASK=/mnt/data/songgang/aibs1/data/Histo/Yuko/preliminary_anatomical_new/input/anatomical_input/volume/anatomical_mask_reheadered.nii.gz

reheader $OLDMASK $NEWMASK


