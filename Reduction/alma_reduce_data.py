# ALMA Data Reduction Script
# for Abell 2597 dataset 2012.1.00988.S

# Note that this script assumes that the raw ASDMs 
# are in a directory called "raw", and that this script sits in a directory 
# called "scripts", both of which sit in the same parent directory

# Calibration application

import os
import sys
import glob

applyonly = True

if (os.path.basename(os.getcwd()) != 'script'):
    sys.exit('ERROR: Please start this script in directory \"script\".')

scriptnames = glob.glob('uid*.ms.scriptForCalibration.py')

if len(scriptnames) == 0:
    sys.exit('ERROR: No calibration script found.')

os.chdir('../raw')

asdmnames = glob.glob('uid*.asdm.sdm')

if len(asdmnames) == 0:
    sys.exit('ERROR: No ASDM found.')

print 'Found the following ASDMs:', asdmnames

for i in range(len(asdmnames)):
    asdmnames[i] = asdmnames[i].replace('.asdm.sdm', '')

for i in range(len(scriptnames)):
    scriptnames[i] = scriptnames[i].replace('.ms.scriptForCalibration.py', '')

if sorted(asdmnames) != sorted(scriptnames):
    sys.exit('ERROR: Inconsistency between ASDMs and calibration scripts.')

if len(asdmnames) > 1 and not os.path.exists('../script/scriptForFluxCalibration.py'):
    sys.exit('ERROR: There are more than one ASDM to calibrate and I could not find a script for flux calibration.')

if not os.path.exists('../calibrated'):
    print 'Creating destination directory for calibrated data.'
    os.mkdir('../calibrated')

os.chdir('../calibrated')

for asdmname in asdmnames:

    print 'Processing ASDM '+asdmname

    os.mkdir(asdmname+'.calibration')

    os.chdir(asdmname+'.calibration')

    if not os.path.exists('../../raw/'+asdmname+'.asdm.sdm'):
        sys.exit('ERROR: cannot find raw/'+asdmname+'.asdm.sdm')

    os.system('ln -sf ../../raw/'+asdmname+'.asdm.sdm '+asdmname)

    execfile('../../script/'+asdmname+'.ms.scriptForCalibration.py')

    if not os.path.exists(asdmname+'.ms.split.cal'):
        print 'ERROR: '+asdmname+'.ms.split.cal was not created.'
    else:
        print asdmname+'.ms.split.cal was produced successfully, moving it to \"calibrated\" directory.'
        os.system('mv '+asdmname+'.ms.split.cal ..')

    os.chdir('..')

if len(asdmnames) > 1:
    execfile('../script/scriptForFluxCalibration.py')

print 'Done. Please find results in current directory.'
