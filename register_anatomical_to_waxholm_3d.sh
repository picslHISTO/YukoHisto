#!/bin/sh

# register 3d waxholm image to 3d anaotomical image to 

ANTS=/home/songgang/mnt/project/ANTStmp/gccrel_itkv4/ANTS
WARP=/home/songgang/mnt/project/ANTStmp/gccrel_itkv4/WarpImageMultiTransform
IMAGEMATH=/home/songgang/mnt/project/ANTStmp/gccrel_itkv4/ImageMath

HISTSLICE=/home/songgang/mnt/data/Histo/Yuko/preliminary_anatomical_new/input/anatomical_input/volume/anatomical_reheadered_masked.nii.gz
HISTMASK=/home/songgang/mnt/data/Histo/Yuko/preliminary_anatomical_new/input/anatomical_input/volume/anatomical_mask_reheadered.nii.gz
HISTMASKDILATED=/home/songgang/mnt/data/Histo/Yuko/preliminary_anatomical_new/input/anatomical_input/volume/anatomical_mask_reheadered_dilated.nii.gz
FULLVOL=/home/songgang/mnt/data/Histo/Yuko/preliminary_anatomical_new/input/waxholm/canon_T1_r_halfsize_origin000_masked.nii.gz
FULLLABEL=/home/songgang/mnt/data/Histo/Yuko/preliminary_anatomical_new/input/waxholm/waxholm_label_halfsize_origin000.nii.gz
OUTPUT=/home/songgang/mnt/data/Histo/Yuko/preliminary_anatomical_new/output/waxholm_to_anatomical_

echo dialte the anatomical mask
echo $IMAGEMATH 3 $HISTMASKDILATED MD $HISTMASK 30
echo

echo using ants to register


echo $ANTS 3 -m MI[$HISTSLICE,$FULLVOL,1,32] \
                -t SyN[0.5,0.1] \
                -r Gauss[10,0.1] \
                -i 200x200x200\
         -x $HISTMASKDILATED \
        -o $OUTPUT \
        --affine-metric-type MI
        
echo

echo warping waxholm and its labels
echo $WARP 3 $FULLVOL ${OUTPUT}warped.nii.gz -R $HISTSLICE ${OUTPUT}Warp.nii.gz ${OUTPUT}Affine.txt
echo $WARP 3 $FULLLABEL ${OUTPUT}warped_label.nii.gz -R $HISTSLICE ${OUTPUT}Warp.nii.gz ${OUTPUT}Affine.txt --use-NN

echo warping using only affine
$WARP 3 $FULLVOL ${OUTPUT}warped_affined.nii.gz -R $HISTSLICE ${OUTPUT}Affine.txt
$WARP 3 $FULLLABEL ${OUTPUT}warped_affined_label.nii.gz -R $HISTSLICE ${OUTPUT}Affine.txt --use-NN
