import re

if re.search('^4.1', casadef.casa_version) == None:
 sys.exit('ERROR: PLEASE USE THE SAME VERSION OF CASA THAT YOU USED FOR GENERATING THE SCRIPT: 4.1')


print "# Flux calibration of the data."


#                                       "J2331-1556"     0     212.98      0.27261      0.26730       2013-11-18T23:14:30  ../calibrated/uid___A002_X7330a2_X383.ms.split
#                                       "J2331-1556"     0     212.98      0.26770      0.26730       2013-11-18T00:44:28  ../calibrated/uid___A002_X7310ce_X4d1.ms.split
#                                       "J2331-1556"     0     212.98      0.26652      0.26730       2013-11-17T01:31:09  ../calibrated/uid___A002_X72e960_X53d.ms.split
#                                       "J2331-1556"     1     214.98      0.27007      0.26629       2013-11-18T23:14:30  ../calibrated/uid___A002_X7330a2_X383.ms.split
#                                       "J2331-1556"     1     214.98      0.26837      0.26629       2013-11-18T00:44:28  ../calibrated/uid___A002_X7310ce_X4d1.ms.split
#                                       "J2331-1556"     1     214.98      0.26530      0.26629       2013-11-17T01:31:09  ../calibrated/uid___A002_X72e960_X53d.ms.split
#                                       "J2331-1556"     2     227.68      0.24526      0.24296       2013-11-18T23:14:30  ../calibrated/uid___A002_X7330a2_X383.ms.split
#                                       "J2331-1556"     2     227.68      0.24380      0.24296       2013-11-18T00:44:28  ../calibrated/uid___A002_X7310ce_X4d1.ms.split
#                                       "J2331-1556"     2     227.68      0.24241      0.24296       2013-11-17T01:31:09  ../calibrated/uid___A002_X72e960_X53d.ms.split
#                                       "J2331-1556"     3     229.68      0.24160      0.23855       2013-11-18T23:14:30  ../calibrated/uid___A002_X7330a2_X383.ms.split
#                                       "J2331-1556"     3     229.68      0.23858      0.23855       2013-11-18T00:44:28  ../calibrated/uid___A002_X7310ce_X4d1.ms.split
#                                       "J2331-1556"     3     229.68      0.23818      0.23855       2013-11-17T01:31:09  ../calibrated/uid___A002_X72e960_X53d.ms.split

setjy(vis = '../calibrated/uid___A002_X7330a2_X383.ms.split.cal',
  field = 'J2331-1556',
  spw = '0',
  fluxdensity = [0.26730, 0, 0, 0])

setjy(vis = '../calibrated/uid___A002_X7310ce_X4d1.ms.split.cal',
  field = 'J2331-1556',
  spw = '0',
  fluxdensity = [0.26730, 0, 0, 0])

setjy(vis = '../calibrated/uid___A002_X72e960_X53d.ms.split.cal',
  field = 'J2331-1556',
  spw = '0',
  fluxdensity = [0.26730, 0, 0, 0])

setjy(vis = '../calibrated/uid___A002_X7330a2_X383.ms.split.cal',
  field = 'J2331-1556',
  spw = '1',
  fluxdensity = [0.26629, 0, 0, 0])

setjy(vis = '../calibrated/uid___A002_X7310ce_X4d1.ms.split.cal',
  field = 'J2331-1556',
  spw = '1',
  fluxdensity = [0.26629, 0, 0, 0])

setjy(vis = '../calibrated/uid___A002_X72e960_X53d.ms.split.cal',
  field = 'J2331-1556',
  spw = '1',
  fluxdensity = [0.26629, 0, 0, 0])

setjy(vis = '../calibrated/uid___A002_X7330a2_X383.ms.split.cal',
  field = 'J2331-1556',
  spw = '2',
  fluxdensity = [0.24296, 0, 0, 0])

setjy(vis = '../calibrated/uid___A002_X7310ce_X4d1.ms.split.cal',
  field = 'J2331-1556',
  spw = '2',
  fluxdensity = [0.24296, 0, 0, 0])

setjy(vis = '../calibrated/uid___A002_X72e960_X53d.ms.split.cal',
  field = 'J2331-1556',
  spw = '2',
  fluxdensity = [0.24296, 0, 0, 0])

setjy(vis = '../calibrated/uid___A002_X7330a2_X383.ms.split.cal',
  field = 'J2331-1556',
  spw = '3',
  fluxdensity = [0.23855, 0, 0, 0])

setjy(vis = '../calibrated/uid___A002_X7310ce_X4d1.ms.split.cal',
  field = 'J2331-1556',
  spw = '3',
  fluxdensity = [0.23855, 0, 0, 0])

setjy(vis = '../calibrated/uid___A002_X72e960_X53d.ms.split.cal',
  field = 'J2331-1556',
  spw = '3',
  fluxdensity = [0.23855, 0, 0, 0])

os.system('rm -rf ../calibrated/uid___A002_X7330a2_X383.ms.split.cal.ampli_inf') 
gaincal(vis = '../calibrated/uid___A002_X7330a2_X383.ms.split.cal',
  caltable = '../calibrated/uid___A002_X7330a2_X383.ms.split.cal.ampli_inf',
  field = 'J2331-1556',
  solint = 'inf',
  combine = 'scan',
  refant = 'DA44',
  gaintype = 'T',
  calmode = 'a')

applycal(vis = '../calibrated/uid___A002_X7330a2_X383.ms.split.cal',
  field = '2,3', # J2331-1556,Abell_2597
  gaintable = '../calibrated/uid___A002_X7330a2_X383.ms.split.cal.ampli_inf',
  gainfield = '2', # J2331-1556
  calwt = F,
  flagbackup = F)

os.system('rm -rf ../calibrated/uid___A002_X7310ce_X4d1.ms.split.cal.ampli_inf') 
gaincal(vis = '../calibrated/uid___A002_X7310ce_X4d1.ms.split.cal',
  caltable = '../calibrated/uid___A002_X7310ce_X4d1.ms.split.cal.ampli_inf',
  field = 'J2331-1556',
  solint = 'inf',
  combine = 'scan',
  refant = 'DA44',
  gaintype = 'T',
  calmode = 'a')

applycal(vis = '../calibrated/uid___A002_X7310ce_X4d1.ms.split.cal',
  field = '2,3', # J2331-1556,Abell_2597
  gaintable = '../calibrated/uid___A002_X7310ce_X4d1.ms.split.cal.ampli_inf',
  gainfield = '2', # J2331-1556
  calwt = F,
  flagbackup = F)

os.system('rm -rf ../calibrated/uid___A002_X72e960_X53d.ms.split.cal.ampli_inf') 
gaincal(vis = '../calibrated/uid___A002_X72e960_X53d.ms.split.cal',
  caltable = '../calibrated/uid___A002_X72e960_X53d.ms.split.cal.ampli_inf',
  field = 'J2331-1556',
  solint = 'inf',
  combine = 'scan',
  refant = 'DA44',
  gaintype = 'T',
  calmode = 'a')

applycal(vis = '../calibrated/uid___A002_X72e960_X53d.ms.split.cal',
  field = '2,3', # J2331-1556,Abell_2597
  gaintable = '../calibrated/uid___A002_X72e960_X53d.ms.split.cal.ampli_inf',
  gainfield = '2', # J2331-1556
  calwt = F,
  flagbackup = F)

print "# Concatenating the data."

for myvis in ['../calibrated/uid___A002_X7330a2_X383.ms.split.cal',
              '../calibrated/uid___A002_X7310ce_X4d1.ms.split.cal',
              '../calibrated/uid___A002_X72e960_X53d.ms.split.cal']:
    os.system('mv '+myvis+' '+myvis+'.mod')
    split(vis=myvis+'.mod', outputvis=myvis)
    os.system('rm -rf '+myvis+'.mod')

concat(vis = ['../calibrated/uid___A002_X7330a2_X383.ms.split.cal', '../calibrated/uid___A002_X7310ce_X4d1.ms.split.cal', '../calibrated/uid___A002_X72e960_X53d.ms.split.cal'],
  concatvis = 'calibrated.ms')
