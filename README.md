
![A2597_MUSE_movie](Misc/A2597_movie.gif)

### Code, calculations, and notes for Tremblay et al. 2016b, ApJ

This repository houses all of the codes and calculations (contained in Jupyter Python notebooks as well as simple Python scripts) associated with our recent paper publishing ALMA and MUSE observations of the cool core brightest cluster galaxy in Abell 2597. 

Specifically, it includes: 

#### Reduction Codes

* `retrieve_[alma/muse]_data.[py/sh]` | Hopefully self-explanatory. If you run into trouble with these, the data is, frankly, just as easily accessible from the [ALMA](http://almascience.nrao.edu/aq/) and [ESO](http://archive.eso.org/cms.html) archives. Both datasets are totally public. 

* `alma_reduce_data.py` | Script to reduce the raw ASDMs (which you download using `retrieve_alma_data.py`) to calibrated measurement sets. These scripts must be run with [CASA] version 4.1, in order to ensure complete reproduction of the data cubes presented in this paper (although later versions of CASA will very likely also work, absent this guarantee). This script also calls `alma_fluxcal_data.py`. Note that running the reduction script will take roughly 12 hours on a reasonably high-end workstation with 64 GB of RAM and a 12 core processor. Machines with fewer cores and/or ram may take (much) longer. 

* `alma_make_cubes.py` | This script image calibrated measurement set (generated with `alma_reduce_data.py`), and create (e.g.) moment maps, a FITS cube of the CO(2-1) and continuum data, etc. Hopefully self-explanatory. 

I have also included a few other scripts of marginal usefulness. They're some odds-n-ends left over from a now very old search for recombination lines, self-calibration of the data using its own continuum, etc. These in principle will work, but have not been super well commented, so your mileage may vary. I'm certainly happy to answer any questions you might have (see below for my email). x


#### Analysis Codes

* `alma_spectral_fitting.ipynb`: A Jupyter notebook showing how we fit gaussians to the extracted CO(2-1) spectra from the datacube. Note that this requires `PySpecKit` by Adam Ginsburg, [which you can download here](http://pyspeckit.bitbucket.org/html/sphinx/index.html) (requires Python 2.7, not 3.x). ASCII files of the spectral data are included. These were saved directly from `CASA v 4.6`, and use data that have been corrected for response of the primary beam. 

* `muse_makemaps.py`: A very rough, terribly formatted, and poorly commented script that will nevertheless make all relevant MUSE maps shown in the paper. I apologize for being too lazy to clean this up!

* `muse_maps_notebook.ipynb`: A slightly cleaner Jupyter Notebook that does much of the above script, in a slightly more readable fashion. Please forgive typos, etc. 

* `*voronoi_*.py`: I include some Voronoi binning codes, too. These are kindly provided by [Michele Cappellari](http://www-astro.physics.ox.ac.uk/~mxc/software/), and adapted to suit our needs. 

* `muse_movie.py`: A code that will make pretty movies of a MUSE or ALMA cube (see the movie above). It's been [adapted from my code here](https://github.com/granttremblay/MUSEmovie). 

* Others in this repo are hopefully pretty self-explanatory. 

As always, please feel free to email me with questions! `grant.tremblay @ cfa.harvard.edu`