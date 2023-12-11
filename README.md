# Image-processing-of-nanoparticles
The codes used for the analysis of quantum dot degradation

# Requirements
All the codes operate in the MATLAB R2021A

# Descriptions
## Morphology of the nanoparticles (NP_contour.m)
Any types of image is available (.jpg, .tif, etc)
Images and this file should be in the same folder to operate the code.
You can adjust the dilation, eroision, binarization values.

## Calculation of EDS signal variance (EDS_polydispersity.m)
tif image, containing only one particles, is required
write down the directory in the myDir, and the file name including .tif in the fileName.

## Detection of subdomain in the nanoparticle (large_area_FFT.m)
Before you start detection, you should know following information
- "pixel per nm" of the image
- The length of the lattice spacing of the material (e.g. for detecting ZnO, 0.254 nm is used, the range should be < 0.1 nm to detect the such materials)

For detecting the subdomain,
The cirular detector is used in the FFT analysis.
Two detectors are used to detect one lattice plane.
Two detectors have in different sizes, about 0.1 nm difference. (you can adjust the size of the detector size if you needed)
you can read the captions in the codes, which describes the codes, line by line.
