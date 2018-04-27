

### Make various A2597 cubes with different velocity widths, weighting, etc. 
### G. Tremblay, grant.tremblay@eso.org

##### Change this stuff ######################
velres = 30 #Velocity resolution / channel width in km/sec
weight = 'natural' # if you use Briggs, you need to also specify a robust factor
robust_for_briggs = 0.5 # needed if using Briggs
sigmacut = 3 # Sigma level above RMS noise / threshold for CLEAN

make_name_unique = '_roberto_looking_for_recom_line_on_shinkansen'
##############################################

threshvalue = sigmacut * 0.18
thresh = str(threshvalue) + 'mJy'


### Clean the MS

clean(vis = 'Abell_2597.CO_21.ms.contsub',
  imagename = str(velres) + 'kms_' + weight + '_' + str(sigmacut) + 'sigma' + make_name_unique + '.clean',
  mode = 'velocity',
  start = '-500km/s',
  width = str(velres) + 'km/s',
  nchan = 21, #EDITED FOR MOVIE - fix this!~!!!!!!
  restfreq = '214.3063487662GHz', ### CHANGED THIS TO LOOK FOR RECOMBINATION LINE!!!
  interpolation = 'linear', #### CHANGED THIS TO LOOK FOR RECOMBINATION LINE!!!!! 
  interactive = F,
  imsize = [300, 300],
  cell = '0.15arcsec',
  weighting =  weight,
  #robust = robust_for_briggs,  # you might need to comment this out if not using briggs - not sure
  pbcor = F,
  uvtaper = F,
  outertaper = ['0.5arcsec'],
  threshold = thresh,
  niter = 1000)


### Split out the moments


immoments(imagename = str(velres) + 'kms_' + weight + '_' + str(sigmacut) + 'sigma' + make_name_unique + '.clean' + '.image',
  moments = [0],
  outfile = str(velres) + 'kms_' + weight + '_' + str(sigmacut) + 'sigma' + make_name_unique  + '.mom0',
  includepix = [0.4e-3, 100])

immoments(imagename = str(velres) + 'kms_' + weight + '_' + str(sigmacut) + 'sigma' + make_name_unique  + '.clean' + '.image',
  moments = [1,2],
  outfile = str(velres) + 'kms_' + weight + '_' + str(sigmacut) + 'sigma' + make_name_unique + '.mom',
  includepix = [0.4e-3, 100])


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

