#!/usr/bin/env python

'''
make_ratio_maps.py:

Note that all ALMA Moment maps were made using Tim Davis' code, here:
/home/grant/Dropbox/ALMA_APJ_PAPER/Final_ALMA_Data/Tim_Code_Figures/

I have also shifted each of these moment maps by (x, y) = (-4, 7) pixels,
using PyRAF, with the following commands:

imdel alma_flux_shift.fits
imdel alma_vel_shift.fits
imdel alma_disp_shift.fits

imshift A2597_mom0.fits alma_flux_shift.fits -4 7
imshift A2597_mom1.fits alma_vel_shift.fits -4 7
imshift A2597_mom2.fits alma_disp_shift.fits -4 7

wcscopy alma_flux_shift.fits A2597_mom0.fits
wcscopy alma_vel_shift.fits A2597_mom1.fits
wcscopy alma_disp_shift.fits A2597_mom2.fits

cp Ha_flux_map.fits muse_flux.fits
cp Ha_vel_map.fits muse_vel.fits
cp Ha_fwhm_map.fits muse_fwhm.fits
'''

from astropy.io import fits
from astropy.wcs import WCS
from astropy.utils.data import get_pkg_data_filename

import numpy as np

from reproject import reproject_interp

import matplotlib.pyplot as plt

# Read in the MUSE data, which we'll leave alone.
muse_flux_HDU = fits.open('muse_flux.fits')
muse_vel_HDU = fits.open('muse_vel.fits')
muse_fwhm_HDU = fits.open('muse_fwhm.fits')

muse_flux_data = muse_flux_HDU[0].data
muse_vel_data = muse_vel_HDU[0].data
muse_fwhm_data = muse_fwhm_HDU[0].data

muse_flux_header = muse_flux_HDU[0].header
muse_vel_header = muse_vel_HDU[0].header
muse_fwhm_header = muse_fwhm_HDU[0].header

# Read in the ALMA data, which we have to fiddle with.
alma_flux_native_HDU = fits.open('alma_flux_shift.fits')
alma_vel_native_HDU = fits.open('alma_vel_shift.fits')
alma_disp_native_HDU = fits.open('alma_disp_shift.fits')

# Create WCS objects for the MUSE and ALMA maps (it doesn't matter)
# which specific moment you use; they're the same for all three.
muse_wcs = WCS(muse_flux_HDU[0])
alma_wcs_native = WCS(alma_flux_native_HDU[0])

# The native ALMA WCS includes two additional axes for velocity
# and polarization. There are no corresponding data axes in Tim's Moment Maps.
# Fix this by simply dropping these irrelevant axes.

alma_wcs_1drop = alma_wcs_native.dropaxis(3)
alma_wcs = alma_wcs_1drop.dropaxis(2)

# Now create a proper (but basically empty) FITS header with this new WCS
new_alma_header = alma_wcs.to_header()

# Now make a new ALMA HDU with the corrected headers.
alma_flux_HDU = fits.PrimaryHDU(data=alma_flux_native_HDU[0].data, header=new_alma_header)
alma_vel_HDU = fits.PrimaryHDU(data=alma_vel_native_HDU[0].data, header=new_alma_header)
alma_disp_HDU = fits.PrimaryHDU(data=alma_disp_native_HDU[0].data, header=new_alma_header)

# We can finally register the ALMA and MUSE data.
alma_flux_reg_data, alma_flux_reg_footprint = reproject_interp(alma_flux_HDU, muse_flux_header)
alma_vel_reg_data, alma_vel_reg_footprint = reproject_interp(alma_vel_HDU, muse_vel_header)
alma_disp_reg_data, alma_disp_reg_footprint = reproject_interp(alma_disp_HDU, muse_fwhm_header)

# Make all zeros in the ALMA data a NaN
alma_flux_reg_data[alma_flux_reg_data == 0] = np.nan
alma_vel_reg_data[alma_vel_reg_data == 0] = np.nan
alma_disp_reg_data[alma_disp_reg_data == 0] = np.nan

# Now you can start dividing the data as you see fit!

def make_fits(data, header, filename):
    'Write a new FITS file.'

    HDU = fits.PrimaryHDU(data=data, header=header)
    HDU.writeto(filename, clobber=True)

    print("Created file: {}".format(filename))

def make_velocity_ratios(muse_vel_data, alma_vel_reg_data, new_alma_header):

    vel_ratio = muse_vel_data - alma_vel_reg_data
    make_fits(vel_ratio, new_alma_header, "testvelocity.fits")

make_velocity_ratios(muse_vel_data, alma_vel_reg_data, new_alma_header)
