#!/bin/sh

# Set number of cores you'd like to use (24 for MUSE data on Hydra)
export OMP_NUM_THREADS=24

export rawdir='/data/sao/gtremblay/Data/MUSE/rawdata'
export caldir='/home/gtremblay/Software/MUSE/calib/muse-2.2/cal'

echo "=======  STARTING REDUCTION OF MUSE DATA ======="

echo "Setting number of OMP threads to " $OMP_NUM_THREADS
echo "Rawdata directory set to: " $rawdir
echo "Static calibration directory set to: " $caldir


echo " "
echo "=======       CREATING MASTER BIAS       ======="
esorex --log-file=bias.log muse_bias --nifu=-1 --merge bias.sof


echo " "
echo "=======       CREATING MASTER DARK       ======="
esorex --log-file=dark.log muse_dark --nifu=-1 --merge dark.sof



echo " "
echo "=======       CREATING MASTER FLAT       ======="
esorex --log-file=flat.log muse_flat --nifu=-1 --merge flat.sof



echo " "
echo "=======      WAVELENGTH CALIBRATION     ======="
esorex --log-file=wavecal.log muse_wavecal --nifu=-1 --resample --residuals --merge wavecal.sof


echo " "
echo "=======       LINE SPREAD FUNCTION      ======="
esorex --log-file=lsf.log muse_lsf --nifu=-1 --merge lsf.sof


echo " "
echo "=======          TWILIGHT FLATS         ======="
esorex --log-file=twilight.log muse_twilight twilight.sof


echo " "
echo "=======    SCIBASIC for SCI FRAMES      ======="
esorex --log-file=science_scibasic.log muse_scibasic --nifu=-1 --merge science_scibasic.sof


echo " "
echo "=======    SCIBASIC for STD FRAME       ======="
esorex --log-file=science_scibasic.log muse_scibasic --nifu=-1 --merge std_scibasic.sof


echo " "
echo "=======        FLUX CALIBRATION         ======="
esorex --log-file=fluxcal.log muse_standard --filter=white fluxcal.sof


echo " "
echo "=======     SCIENCE POSTPROCESSING      ======="

esorex --log-file=science_scipost.log muse_scipost --filter=white,Johnson_V,Cousins_R,Cousins_I --save=cube,individual --skymodel_fraction=0.3 --skymethod=simple science_scipost_1.sof
cp IMAGE_FOV_0001.fits IMAGE_FOV_0001_1.fits
cp IMAGE_FOV_0002.fits IMAGE_FOV_0002_1.fits
cp IMAGE_FOV_0003.fits IMAGE_FOV_0003_1.fits
cp PIXTABLE_REDUCED_0001.fits PIXTABLE_REDUCED_0001_1.fits
cp DATACUBE_FINAL.fits DATACUBE_SINGLE_FINAL_0001_1.fits
esorex --log-file=science_scipost.log muse_scipost --filter=white,Johnson_V,Cousins_R,Cousins_I --save=cube,individual --skymodel_fraction=0.3 --skymethod=simple science_scipost_2.sof
cp IMAGE_FOV_0001.fits IMAGE_FOV_0001_2.fits
cp IMAGE_FOV_0002.fits IMAGE_FOV_0002_2.fits
cp IMAGE_FOV_0003.fits IMAGE_FOV_0003_2.fits
cp PIXTABLE_REDUCED_0001.fits PIXTABLE_REDUCED_0001_2.fits
cp DATACUBE_FINAL.fits DATACUBE_SINGLE_FINAL_0001_2.fits
esorex --log-file=science_scipost.log muse_scipost --filter=white,Johnson_V,Cousins_R,Cousins_I --save=cube,individual --skymodel_fraction=0.3 --skymethod=simple science_scipost_3.sof
cp IMAGE_FOV_0001.fits IMAGE_FOV_0001_3.fits
cp IMAGE_FOV_0002.fits IMAGE_FOV_0002_3.fits
cp IMAGE_FOV_0003.fits IMAGE_FOV_0003_3.fits
cp PIXTABLE_REDUCED_0001.fits PIXTABLE_REDUCED_0001_3.fits
cp DATACUBE_FINAL.fits DATACUBE_SINGLE_FINAL_0001_3.fits

echo " "
echo "=======  ALIGN AND COMBINE   ======="

echo "Aligning cubes..."
esorex muse_exp_align align.sof

echo "Combining cubes..."
esorex muse_exp_combine --pixfrac=0.8 --filter=white,Johnson_V,Cousins_R,Cousins_I combine_without_offset_list.sof

echo "Renaming DATACUBE_FINAL.fits to DATACUBE_DIRTY.fits"
mv DATACUBE_FINAL.fits DATACUBE_DIRTY.fits
