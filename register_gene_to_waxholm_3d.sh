#!/bin/sh

# register 3d waxholm image to 3d gene using affine

GENE=$1
# GENE=E80_00876

ANTS=/home/songgang/mnt/project/ANTStmp/gccrel_itkv4/ANTS
WARP=/home/songgang/mnt/project/ANTStmp/gccrel_itkv4/WarpImageMultiTransform
IMAGEMATH=/home/songgang/mnt/project/ANTStmp/gccrel_itkv4/ImageMath
GRID=/home/songgang/mnt/project/ANTStmp/gccrel_itkv4/CreateWarpedGridImage
COMPOSE=/home/songgang/mnt/project/ANTStmp/gccrel_itkv4/ComposeMultiTransform

HISTSLICE=/home/songgang/mnt/data/Histo/Yuko/preliminary_anatomical_new/input/new12case/$GENE/volume/${GENE}_reheadered.nii.gz
HISTMASK=/home/songgang/mnt/data/Histo/Yuko/preliminary_anatomical_new/input/new12case/$GENE/volume/${GENE}_reheadered_mask.nii.gz

OUTPUT=/home/songgang/mnt/data/Histo/Yuko/preliminary_anatomical_new/input/new12case/$GENE/volume/${GENE}_to_waxholm_dmmfd_


# HISTSLICE=/home/songgang/mnt/data/Histo/Yuko/preliminary_anatomical_new/input/Lhx6/volume/Lhx6_reheadered.nii.gz
# HISTMASK=/home/songgang/mnt/data/Histo/Yuko/preliminary_anatomical_new/input/Lhx6/volume/Lhx6_reheadered_mask.nii.gz
# HISTMASKDILATED=/home/songgang/mnt/data/Histo/Yuko/preliminary_anatomical_new/input/Lhx6/volume/Lhx6_reheadered_mask_dilated.nii.gz

FULLVOLMASK=/home/songgang/mnt/data/Histo/Yuko/preliminary_anatomical_new/input/waxholm/waxholm_brainmask_halfsize_origin000.nii.gz
FULLLABEL=/home/songgang/mnt/data/Histo/Yuko/preliminary_anatomical_new/input/waxholm/waxholm_label_halfsize_origin000.nii.gz
FULLVOLMASKDILATED=/home/songgang/mnt/data/Histo/Yuko/preliminary_anatomical_new/input/waxholm/waxholm_brainmask_halfsize_origin000_dilated.nii.gz



echo "==>" dialte the anatomical mask
echo 
echo $IMAGEMATH 3 $FULLVOLMASKDILATED MD $FULLVOLMASK 30
echo

echo "==>" using ants to register
echo
$ANTS 3 -m MI[$FULLVOLMASK,$HISTMASK,1,32] \
                -t Elast[0.5] \
                -r DMFFD[4x4x4,3] \
                -i 100x100x100\
        -o $OUTPUT \
		-x $FULLVOLMASKDILATED 
echo

# echo without transform
# $WARP 3 $FULLLABEL ${OUTPUT}warped_id_label.nii.gz -R $HISTSLICE --Id --use-NN


echo "==>" warping $GENE and mask
$WARP 3 $HISTSLICE ${OUTPUT}warped_histo.nii.gz -R $FULLVOLMASK ${OUTPUT}Warp.nii.gz ${OUTPUT}Affine.txt
$WARP 3 $HISTMASK ${OUTPUT}warped_mask.nii.gz -R $FULLVOLMASK ${OUTPUT}Warp.nii.gz ${OUTPUT}Affine.txt --use-NN


# echo "==>" warping Lhx6 and mask
# echo
# $WARP 3 $HISTSLICE ${OUTPUT}warped_affined_histo.nii.gz -R $FULLVOLMASK ${OUTPUT}Warp.nii.gz ${OUTPUT}Affine.txt
# $WARP 3 $HISTMASK ${OUTPUT}warped_affined_mask.nii.gz -R $FULLVOLMASK ${OUTPUT}Warp.nii.gz ${OUTPUT}Affine.txt --use-NN
# echo

# echo $WARP 3 $FULLLABEL ${OUTPUT}warped_affined_label.nii.gz -R $HISTSLICE ${OUTPUT}Affine.txt --use-NN
echo


echo
echo
echo
# echo warping using only affine

# echo $COMPOSE 3 ${OUTPUT}Affine_field.nii.gz -R $HISTSLICE ${OUTPUT}Affine.txt
# echo $GRID 3 ${OUTPUT}Affine_field.nii.gz ${OUTPUT}warped_affined_warped_grid.nii.gz 1x1x1 3x3x3  
# echo c3d ${OUTPUT}warped_affined_warped_grid.nii.gz -scale -1 -shift 255 -threshold 128 Inf 1 0 -o ${OUTPUT}warped_affined_warped_grid_mask.nii.gz

echo
echo
echo
# echo warping using affine+dmmfd

# echo $COMPOSE 3 ${OUTPUT}Final_field.nii.gz -R $HISTSLICE ${OUTPUT}Warp.nii.gz ${OUTPUT}Affine.txt
# echo $WARP 3 $FULLVOLMASK ${OUTPUT}warped_mask.nii.gz -R $HISTSLICE ${OUTPUT}Warp.nii.gz ${OUTPUT}Affine.txt --use-NN
# echo $WARP 3 $FULLLABEL ${OUTPUT}warped_label.nii.gz -R $HISTSLICE ${OUTPUT}Warp.nii.gz ${OUTPUT}Affine.txt --use-NN
# echo $GRID 3 ${OUTPUT}Final_field.nii.gz ${OUTPUT}warped_grid.nii.gz 1x1x1 3x3x3
# echo c3d ${OUTPUT}warped_grid.nii.gz -scale -1 -shift 255 -threshold 128 Inf 1 0 -o ${OUTPUT}warped_grid_mask.nii.gz



