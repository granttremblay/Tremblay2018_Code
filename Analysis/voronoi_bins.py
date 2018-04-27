import voronoi_new
import numpy
from astropy.io import fits as pyfits
from scipy import ndimage

name='A2597'
input_cube='../%s.final.fits'%name
continuum_signal_band=(6000,6200)
target_sn=100
max_area=3000

hdu = pyfits.open(input_cube)
data = hdu[0].data
select = numpy.isnan(data)
data[select] = 0
error = numpy.sqrt(hdu[1].data)
error[select]=1e9
hdr = hdu[0].header
wave = numpy.arange(hdr['NAXIS3'])*1.25 + hdr['CRVAL3']
hdu.close()
select_wave = (wave>continuum_signal_band[0])  & (wave<continuum_signal_band[1])
mean_img = numpy.mean(data[select_wave,:,:],0)
err_img = numpy.std(data[select_wave,:,:],0)

# Mask that lower point source
mean_img[256:321,38:87]=0
hdu = pyfits.PrimaryHDU(mean_img)
hdu.writeto('signal_cont.fits',clobber=True)

hdu = pyfits.PrimaryHDU(err_img)
hdu.writeto('noise_cont.fits',clobber=True)

voronoi_new.binning_fits('signal_cont.fits','noise_cont.fits',target_sn,name,max_area=max_area,gersho=True,plot=False)

def bin_cube(voronoi_pixel,input_cube,output_rss):
  hdu = pyfits.open(input_cube)
  data = hdu[0].data
  select = numpy.isnan(data)
  data[select] = 0
  error = numpy.sqrt(hdu[1].data)
  error[select]=1e9
  hdr = hdu[0].header
  wave = numpy.arange(hdr['NAXIS3'])*1.25 + hdr['CRVAL3']
  hdu.close()

  ascii_in = open(voronoi_pixel,'r')
  lines = ascii_in.readlines()
  x = numpy.arange(len(lines)-1,dtype=numpy.int16)
  y = numpy.arange(len(lines)-1,dtype=numpy.int16)
  binNr = numpy.arange(len(lines)-1,dtype=numpy.int16)
  for i in range(1,len(lines)):
    line = lines[i].split()
    x[i-1]=int(line[0])
    y[i-1]=int(line[1])
    binNr[i-1]=int(line[2])

  rss_data = numpy.zeros((max(binNr),len(wave)),dtype=numpy.float32)
  rss_error = numpy.zeros((max(binNr),len(wave)),dtype=numpy.float32)

  for l in range(max(binNr)):
    select_bin = binNr==(l+1)
    x_bin = x[select_bin]-1
    y_bin = y[select_bin]-1
    for j in range(len(x_bin)):
	  rss_data[l,:] += data[:,y_bin[j],x_bin[j]]
	  rss_error[l,:] += error[:,y_bin[j],x_bin[j]]**2
    rss_error[l,:] = numpy.sqrt(rss_error[l,:])
  rss_error[numpy.isnan(rss_error)]=1e9
  rss_out = pyfits.HDUList([pyfits.PrimaryHDU(rss_data),pyfits.ImageHDU(rss_error,name='ERROR'),pyfits.ImageHDU(numpy.zeros(rss_data.shape,dtype=numpy.uint16),name='MASK')])
  rss_out[0].header = hdr
  rss_out[0].header['CDELT1'] = 1.25
  rss_out[0].header['CRVAL1'] = hdr['CRVAL3']
  rss_out[0].header['CRPIX1'] = 1
  rss_out.writeto(output_rss,clobber=True,output_verify='fix')

bin_cube('%s.voronoi.pixel.dat'%(name),input_cube,'%s.voronoi_rss.fits'%(name))
