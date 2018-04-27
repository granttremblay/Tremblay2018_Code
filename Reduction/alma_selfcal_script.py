# Script that splits the continuum-only data set and self-calibrates 

import os 

mystep=11 


###### Splitting the continuum-only data #####
# NOTE: it does not contain all the channels without line in each spw, 
# but CASA does not yet support more than one channel range separated 
# by ';' in split

if mystep==0: 
    split(vis='calibrated_IRAS1816.split', outputvis='calibrated_IRAS1816.split.cont', field='', datacolumn='data', width='5', spw = '0:0~87,4:0~87,8:0~87,12:0~87,1,5,9,13,2:120~190,6:120~190,10:120~190,14:120~190,3:50~165,7:50~165,11:50~165,15:50~165')
# create data that will be selfcalibrated 

    split(vis='calibrated_IRAS1816.split', outputvis='calibrated_IRAS1816.split.cont.noSC', field='', datacolumn='data', width='5', spw = '0:0~87,4:0~87,8:0~87,12:0~87,1,5,9,13,2:120~190,6:120~190,10:120~190,14:120~190,3:50~165,7:50~165,11:50~165,15:50~165')
# create data set that will not be selfcalibrated 

##### ##### #####

### Delete model representations in data #####

elif mystep==1:
    #delmod(vis='calibrated_IRAS1816.split.cont', otf=True, field='', scr=False, async=False)
    clearcal(vis='calibrated_IRAS1816.split.cont')

##### ##### #####



##### First imaging prior to self-cal ##### 
# only 100 iterations with boxes around two bright sources
# peak=74.1 mJy/b, noise=0.19 mJy/b SN=390

elif mystep==2:
    os.system('rm -rf cont_presc_v1*')
    clean(vis='calibrated_IRAS1816.split.cont', imagename='cont_presc_v1', spw='0~15', field='', mode='mfs', imsize=[512,512], cell='0.2arcsec', interactive=True, weighting='natural', niter=10000, usescratch=False, threshold='0.2mJy')

#Check that there are clean components
# plotms(vis='calibrated_IRAS1816.split.cont', xaxis='time', yaxis='amp', field='', spw='', avgchannel='5', ydatacolumn='model', xselfscale=True, yselfscale=True)

##### ##### #####

##### First selfcal #####

elif mystep==3: 
    os.system('rm -rf cont.SC.p1')
    gaincal(vis='calibrated_IRAS1816.split.cont', caltable='cont.SC.p1', gaintype='G',  calmode='p', solint='60s', minsnr=3.0, minblperant=4, refant='DA59')
# refant='DA59' determined by looking for at the refant of the calibration of individual blocks 
# and good phase rms before and after wvr correction in case it was not used

# Check the solutions
# plotcal(caltable='cont.SC.p1',xaxis='time',yaxis='phase', spw='',iteration='antenna',subplot=411,plotrange=[0,0,-180,180], antenna='',timerange='')
# plotcal(caltable='cont.SC.p1',xaxis='time',yaxis='amp', spw='',iteration='antenna',subplot=411, antenna='',timerange='')


##### ##### #####

##### Application of first selfcal #####

elif mystep==4:
    applycal(vis='calibrated_IRAS1816.split.cont', gaintable=['cont.SC.p1'], calwt=True, flagbackup=False)

##### ##### #####

##### Cleaning after First self-cal round #####

elif mystep==5: 
    
    os.system('rm -rf cont_sc1_v1*')
    clean(vis='calibrated_IRAS1816.split.cont', imagename='cont_sc1_v1', spw='0~15', field='', mode='mfs', imsize=[512,512], cell='0.2arcsec', interactive=True, weighting='natural', niter=10000, usescratch=False, threshold='0.2mJy', mask='cont_presc_v1.mask')
# clean now 2x100 first in inner mask and then outside

##### ##### #####

##### Second selfcal #####

elif mystep==6: 
    os.system('rm -rf cont.SC.p2')
    gaincal(vis='calibrated_IRAS1816.split.cont', caltable='cont.SC.p2', gaintype='G',  calmode='p', solint='40s', minsnr=3.0, minblperant=4, refant='DA59')
# refant='DA59' determined by looking for at the refant of the calibration of individual blocks 
# and good phase rms before and after wvr correction in case it was not used

# Check the solutions
# plotcal(caltable='cont.SC.p2',xaxis='time',yaxis='phase', spw='',iteration='antenna',subplot=411,plotrange=[0,0,-180,180], antenna='',timerange='')
# plotcal(caltable='cont.SC.p2',xaxis='time',yaxis='amp', spw='',iteration='antenna',subplot=411, antenna='',timerange='')


##### ##### #####
##### Application of second selfcal #####

elif mystep==7:
    applycal(vis='calibrated_IRAS1816.split.cont', gaintable=['cont.SC.p2'], calwt=True, flagbackup=False)

##### ##### #####

##### Cleaning after Second self-cal round #####

elif mystep==8: 
    
    os.system('rm -rf cont_sc2_v1*')
    clean(vis='calibrated_IRAS1816.split.cont', imagename='cont_sc2_v1', spw='0~15', field='', mode='mfs', imsize=[512,512], cell='0.2arcsec', interactive=True, weighting='natural', niter=10000, usescratch=False, threshold='0.2mJy', mask='cont_presc_v1.mask')
# First only x100 in central boxes to compare to cont_presc_v1.image and decide whether 
# more selfcal iterations are useful. If yes, then clean deeper than x200
# Result: No more self-cal needed

##### ##### #####


### Final Imaging ###


elif mystep==9: 
    
    os.system('rm -rf cont_sc2_v2*')
    clean(vis='calibrated_IRAS1816.split.cont', imagename='cont_sc2_v2', spw='0~15', field='', mode='mfs', imsize=[512,512], cell='0.2arcsec', interactive=True, weighting='natural', niter=10000, usescratch=False, threshold='0.1mJy', mask='cont_presc_v1.mask')
# go deep with interactive cleaning in selcalibrated data 


    os.system('rm -rf cont_presc_v2*')
    clean(vis='calibrated_IRAS1816.split.cont.noSC', imagename='cont_presc_v2', spw='0~15', field='', mode='mfs', imsize=[512,512], cell='0.2arcsec', interactive=True, weighting='natural', niter=10000, usescratch=False, threshold='0.1mJy', mask='cont_presc_v1.mask')
# go deep with interactive cleaning in selcalibrated data 


##### Applying selcal solutions to line data #####

elif mystep==10:

    applycal(vis='calibrated_IRAS1816.fullres.split.contsub', gaintable=['cont.SC.p2'], calwt=True, flagbackup=False)

##### ##### #####


##### Make images of one line before and after selfcal #####

elif mystep==11: 

    os.system('rm -rf H39_sc_v1*')
    clean(vis='calibrated_IRAS1816.fullres.split.contsub', imagename='H39_sc_v1', field = '', spw='0,4,8,12', mode = 'velocity', start = '-80km/s', width = '1km/s', outframe = 'LSRK', nchan = 180, restfreq = '106.73736GHz', interpolation = 'linear', threshold = '', interactive = F, imsize = [512,512], cell = '0.2arcsec', weighting = 'natural', niter = 500)
# and compare with 'H39_v2.image'




else: 
    print('No valid step')


