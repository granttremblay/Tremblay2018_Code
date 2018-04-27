
### Make various A2597 cubes with different velocity widths, weighting, etc. 
### G. Tremblay, grant.tremblay@eso.org
import os

##### Change this stuff ######################
velres = 10 #Velocity resolution / channel width in km/sec
weight = 'natural' # if you use Briggs, you need to also specify a robust factor
robust_for_briggs = 2.0 # needed if using Briggs
sigmacut =3.0 # Sigma level above RMS noise / threshold for CLEAN
taper = True # Tapering decreases resolution and increases sensitivity to extended structures
primary_beam_correction = True # PBcorr? 


run_name = 'put_run_name_here'
blue_edge =-500
symmetric = True
manual_nchannels = 111
includepix_moments = -1 # -1 is all pixels, otherwise do something like this: [0.4e-3, 100]


##############################################

threshvalue = sigmacut * 0.18
thresh = str(threshvalue) + 'mJy'


nchan_symmetric = 1 + (abs(2*blue_edge) / velres) 


## Get the name right

make_name_unique = '_' + run_name


if symmetric == True:
    nchannels = nchan_symmetric
else: 
    nchannels = manual_nchannels

### Clean the MS

clean(vis = 'Abell_2597.CO_21.ms.contsub',
  imagename = str(velres) + 'kms_' + weight + '_' + str(sigmacut) + 'sigma' + make_name_unique + '.clean',
  mode = 'velocity',
  start = str(blue_edge) + 'km/s',
  width = str(velres) + 'km/s',
  nchan = nchannels, 
  restfreq = '213.04685GHz', 
  interpolation = 'nearest',  
  interactive = F,
  imsize = [300, 300],
  cell = '0.15arcsec',
  weighting =  weight,
  #robust = robust_for_briggs,  # you might need to comment this out if not using briggs - not sure
  pbcor = primary_beam_correction,
  uvtaper = taper,
  outertaper = ['0.5arcsec'], # only used if you're tapering. 
  threshold = thresh,
  niter = 1000)


### Split out the moments

immoments(imagename = str(velres) + 'kms_' + weight + '_' + str(sigmacut) + 'sigma' + make_name_unique + '.clean' + '.image',
  moments = [0],
  outfile = str(velres) + 'kms_' + weight + '_' + str(sigmacut) + 'sigma' + make_name_unique  + '.mom0',
  includepix = includepix_moments)

immoments(imagename = str(velres) + 'kms_' + weight + '_' + str(sigmacut) + 'sigma' + make_name_unique  + '.clean' + '.image',
  moments = [1,2],
  outfile = str(velres) + 'kms_' + weight + '_' + str(sigmacut) + 'sigma' + make_name_unique + '.mom',
  includepix = includepix_moments)


### Make FITS images including the cube and the moment maps

exportfits( imagename = str(velres) + 'kms_' + weight + '_' + str(sigmacut) + 'sigma' + make_name_unique + '.clean' + '.image',
  fitsimage = str(velres) + 'kms_' + weight + '_' + str(sigmacut) + 'sigma' + make_name_unique + '.fits',
  velocity = True)

exportfits( imagename = str(velres) + 'kms_' + weight + '_' + str(sigmacut) + 'sigma' + make_name_unique + '.mom0',
  fitsimage = str(velres) + 'kms_' + weight + '_' + str(sigmacut) + 'sigma' + make_name_unique  + '_IntensityMap.fits')

exportfits( imagename = str(velres) + 'kms_' + weight + '_' + str(sigmacut) + 'sigma' + make_name_unique + '.mom' + '.weighted_coord',
  fitsimage = str(velres) + 'kms_' + weight + '_' + str(sigmacut) + 'sigma' + make_name_unique + '_VelocityMap.fits')

exportfits( imagename = str(velres) + 'kms_' + weight + '_' + str(sigmacut) + 'sigma' + make_name_unique + '.mom' + '.weighted_dispersion_coord',
  fitsimage = str(velres) + 'kms_' + weight + '_' + str(sigmacut) + 'sigma' + make_name_unique  +'_VelocityDispersion.fits')

final_cube_name = str(velres) + 'kms_' + weight + '_' + str(sigmacut) + 'sigma' + make_name_unique + '.fits'



print "Made the following maps:"
print final_cube_name + " (the full data cube)"
print final_cube_name[:-5] + "_IntensityMap.fits (Intensity / moment 0)"
print final_cube_name[:-5] + "_VelocityMap.fits (Velocity map in km/s)"
print final_cube_name[:-5] + "_VelocityDispersion.fits (Vel. Dispersion map in km/s)"

