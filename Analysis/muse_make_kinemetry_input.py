#!/usr/bin/env python

'''
Quick script to convert a CARS/PyParadise MUSE Stellar fit table into
the data table format required by Davor's KINEMETRY IDL code, namely a table with:

  #     XBIN        YBIN       VEL       ER_VEL      SIG       ER_SIG
  1    -5.6000    -3.2000  1924.2612     5.0021   167.5929     6.6316
  2    -5.6000    -2.4000  1949.4697     5.5172   158.1428    15.0470
  3    -5.6000    -1.6000  1973.5778     7.1749   136.1071    13.4320
  4    -5.6000    -0.8000  1995.6958     5.9493   157.8206     9.3654
  5    -5.6000     0.0000  2009.0918     5.2744   159.3050     6.0594

 (where SIG is velocity dispersion)
'''

from astropy.io import fits
from astropy.io import ascii
from astropy.table import Table
import astropy.constants as const

import numpy as np

from argparse import ArgumentParser
import os.path


def main():

	parser = ArgumentParser(description="Convert a PyParadise kin_table to an input file for Kinemetry")

	parser.add_argument("filename", help="Input stellar fit table from PyParadise (e.g. *.kin_table.fits)")
	parser.add_argument("fovimage", help="FOV image, e.g. IMG_FOV_0001.fits")	
	parser.add_argument("redshift", help="Source redshift (e.g. z=     )")

	args = parser.parse_args()


	z = args.redshift 
	cz = z * const.c.to('km/s')

	fov = args.fovimage
	stars = args.filename

	# Read in the stellar table, from which we'll make stellar maps
	data = fits.getdata(stars)
	#stellar_tab = stellar_hdu[1].data

	table = Table(data)

	bin_number =np.arange(1, len(table["x_cor"]) + 1)

	# Now construct a new table formatted as Kinemetry expects

	print(table["y_cor"].data)

	kinemetry_table = Table([bin_number, 
		 					table["x_cor"].data, 
		 					table["y_cor"].data, 
		 					table["vel_fit"].data, 
		 					table["vel_fit_err"].data, 
		 					table["disp_fit"].data, 
		 					table["disp_fit_err"].data],
		 					names=["#", "XBIN", "YBIN", "VEL", "ER_VEL", "SIG", "ER_SIG"]
		 					)
	ascii.write(kinemetry_table, "kinemetry_table.dat", overwrite=True)


def is_valid_file(parser, arg):
    if not os.path.exists(arg):
        parser.error("The file %s does not exist!" % arg)
    else:
        return open(arg, 'r')  # return an open file handle



if __name__ == '__main__':
	main()

