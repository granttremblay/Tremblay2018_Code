### Code, calculations, and notes for Tremblay et al. 2016b, ApJ


![A2597_MUSE_movie](Misc/A2597_movie.gif)


This repository houses all of the codes and calculations (contained in Jupyter Python notebooks as well as simple Python scripts) associated with our recent paper publishing ALMA and MUSE observations of the cool core brightest cluster galaxy in Abell 2597. 

Specifically, it includes: 

#### Reduction Codes




#### Analysis Codes

* `alma_spectral_fitting.ipynb`: A Jupyter notebook showing how we fit gaussians to the extracted CO(2-1) spectra from the datacube. Note that this requires `PySpecKit` by Adam Ginsburg, [which you can download here](http://pyspeckit.bitbucket.org/html/sphinx/index.html) (requires Python 2.7, not 3.x). ASCII files of the spectral data are included. These were saved directly from `CASA v 4.6`, and use data that have been corrected for response of the primary beam. 

* `muse_makemaps.py`: A very rough, terribly formatted, and poorly commented script that will nevertheless make all relevant MUSE maps shown in the paper. I apologize for being too lazy to clean this up!

* `muse_maps_notebook.ipynb`: A slightly cleaner Jupyter Notebook that does much of the above script, in a slightly more readable fashion. Please forgive typos, etc. 

* `*voronoi_*.py`: I include some Voronoi binning codes, too. These are kindly provided by [Michele Cappellari](http://www-astro.physics.ox.ac.uk/~mxc/software/), and adapted to suit our needs. 

* `muse_movie.py`: A code that will make pretty movies of a MUSE or ALMA cube (see the movie above). It's been [adapted from my code here](https://github.com/granttremblay/MUSEmovie). 

* Others in this repo are hopefully pretty self-explanatory. 

As always, please feel free to email me with questions! `grant.tremblay @ cfa.harvard.edu`